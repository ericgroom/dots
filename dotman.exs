#! /usr/bin/env elixir
Mix.install([:yaml_elixir])

defmodule TemplateParser do
  def parse(str) do
    str
    |> String.split("\n")
    |> Enum.map(fn line ->
      cond do
        String.starts_with?(line, "#tags") ->
          case parse_tag_line(line) do
            {:ok, tags} ->
              {:tag_open, tags}

            {:error, text} ->
              {:text, text}
          end

        String.starts_with?(line, "#end") ->
          {:tag_close, nil}

        true ->
          {:text, line}
      end
    end)
    |> group_lines()
  end

  defp parse_tag_line(line) do
    tag_list =
      line
      |> String.replace_prefix("#tags", "")
      |> String.trim()

    with true <- String.starts_with?(tag_list, "("),
         true <- String.ends_with?(tag_list, ")") do
      tags_str = tag_list |> String.replace_prefix("(", "") |> String.replace_suffix(")", "")

      tags =
        tags_str
        |> String.split(",")
        |> Enum.map(&String.trim/1)

      {:ok, tags}
    else
      _ ->
        {:error, line}
    end
  end

  defp group_lines(lines, result \\ [])
  defp group_lines([], result), do: result

  defp group_lines([line | lines], result) do
    # iterate through lines
    # if currently parsing text, just append
    # if encounters a taglist, iterate until matching close is found and return remainder
    case line do
      {:text, text} ->
        {previous, result} = List.pop_at(result, -1)

        case previous do
          nil ->
            group_lines(lines, [{:text, text}])

          {:text, previous_text} ->
            group_lines(lines, result ++ [{:text, join(previous_text, text)}])

          _ ->
            group_lines(lines, result ++ [previous, {:text, text}])
        end

      {:tag_open, _} ->
        {block, rest} = take_tagblock([line | lines])
        group_lines(rest, result ++ [block])
    end
  end

  defp take_tagblock(lines) do
    [{:tag_open, tags} | rest] = lines

    {tagged, [_tag_close | rest]} =
      Enum.split_while(rest, fn
        {:text, _} -> true
        {:tag_close, _} -> false
      end)

    text =
      Enum.reduce_while(tagged, "", fn line, acc ->
        case line do
          {:text, text} ->
            {:cont, join(acc, text)}

          {:tag_open, _} ->
            raise "nested tags not supported"

          {:tag_close, _} ->
            {:halt, acc}
        end
      end)

    {{:tag_block, tags, text}, rest}
  end

  defp join(acc, line)
  defp join("", line), do: line
  defp join(acc, line), do: acc <> "\n" <> line
end

config_path = "./systems.yaml"
iam_path = "./iam"

iam = File.read!(iam_path)
config = YamlElixir.read_from_file!(config_path)
systems = config["systems"]
programs = config["programs"]
current_system = Map.fetch!(systems, iam)
enabled_programs = Map.get(current_system, "programs", [])
enabled_tags = Map.get(current_system, "tags", []) |> MapSet.new()

if not File.exists?("build") do
  File.mkdir!("build")
end

# for each program
enabled_programs
|> Enum.map(fn program ->
  File.mkdir_p!(Path.join([".", "build", program]))
  banned_dirs = (get_in(programs, [program, "stowignore"]) || []) |> MapSet.new()

  files_to_copy =
    Path.join([".", program, "**"])
    |> Path.wildcard(match_dot: true)
    |> Enum.reject(fn path ->
      Path.split(path)
      |> Enum.any?(&MapSet.member?(banned_dirs, &1))
    end)

  {dirs, files} = Enum.split_with(files_to_copy, &File.dir?/1)
  new_path_factory = fn p -> Path.join([".", "build", p]) end

  dirs
  |> Enum.map(new_path_factory)
  |> Enum.each(&File.mkdir_p!/1)

  files_to_process =
    files
    |> Enum.map(fn old_path ->
      new_path = new_path_factory.(old_path)
      File.cp!(old_path, new_path)
      new_path
    end)

  files_to_process
  |> Enum.each(fn file ->
    contents = File.read!(file)

    new_contents =
      TemplateParser.parse(contents)
      |> Enum.map(fn
        {:text, text} ->
          text

        {:tag_block, tags, text} ->
          if Enum.any?(tags, &MapSet.member?(enabled_tags, &1)), do: text, else: ""
      end)
      |> Enum.join("\n")

    File.write!(file, new_contents)
  end)

  System.cmd("stow", [program, "--no-folding", "--target=#{System.user_home!()}"], cd: "./build")
end)
