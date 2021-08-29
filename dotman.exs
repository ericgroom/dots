#! /usr/bin/env elixir
Mix.install([:yaml_elixir])

defmodule DotMan.TemplateParser do
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

defmodule DotMan.Env do
  def config_path, do: "./systems.yaml"
  def iam_path, do: "./iam"
end

defmodule DotMan.Compiler do
  alias DotMan.{Config, TemplateParser}

  defp ensure_output_dir_exists(program) do
    File.mkdir_p!(Path.join([".", "build", program]))
  end

  def compile_all(config, iam) do
    enabled_programs = Config.enabled_programs(config, iam)

    enabled_programs
    |> Enum.each(fn program -> compile(program, config, iam) end)
  end

  def compile(program, config, iam) do
    ensure_output_dir_exists(program)
    enabled_tags = Config.enabled_tags(config, iam)

    files_to_copy = files_to_process(program, config)

    files_to_copy
    |> Enum.map(&Path.dirname/1)
    |> Enum.map(&build_destination_for_source_file/1)
    |> Enum.each(&File.mkdir_p!/1)

    files_to_compile =
      files_to_copy
      |> Enum.map(fn source_path ->
        dest_path = build_destination_for_source_file(source_path)
        File.cp!(source_path, dest_path)
        dest_path
      end)

    files_to_compile
    |> Enum.each(&compile_file(&1, enabled_tags))

    stow_compiled_program(program)
  end

  defp build_destination_for_source_file(path) do
    Path.join([".", "build", path])
  end

  defp files_to_process(program, config) do
    banned_dirs = Config.stowignore(config, program)

    Path.join([".", program, "**"])
    |> Path.wildcard(match_dot: true)
    |> Enum.reject(fn path ->
      Path.split(path)
      |> Enum.any?(&MapSet.member?(banned_dirs, &1))
    end)
    |> Enum.reject(&File.dir?/1)
  end

  defp compile_file(file, enabled_tags) do
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
  end

  defp stow_compiled_program(program) do
    System.cmd("stow", [program, "--no-folding", "--target=#{System.user_home!()}"], cd: "./build")
  end
end

defmodule DotMan.Config do
  def new(path) do
    YamlElixir.read_from_file!(path)
  end

  def systems(config) do
    config["systems"]
  end

  def programs(config) do
    config["programs"]
  end

  def current_system(config, iam) do
    systems(config)
    |> Map.fetch!(iam)
  end

  def enabled_programs(config, iam) do
    Map.get(current_system(config, iam), "programs", []) |> MapSet.new()
  end

  def enabled_tags(config, iam) do
    Map.get(current_system(config, iam), "tags", []) |> MapSet.new()
  end

  def stowignore(config, program) do
    (get_in(programs(config), [program, "stowignore"]) || []) |> MapSet.new()
  end
end

alias DotMan.{Compiler, Config, Env}

iam = File.read!(Env.iam_path())
config = Config.new(Env.config_path())

Compiler.compile_all(config, iam)
