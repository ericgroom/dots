Mix.install([:yaml_elixir])

config_path = "./systems.yaml"
iam_path = "./iam"

iam = File.read!(iam_path)
config = YamlElixir.read_from_file!(config_path)
systems = config["systems"]
programs = config["programs"]
current_system = Map.fetch!(systems, iam)
enabled_programs = Map.get(current_system, "programs", [])
enabled_tags = Map.get(current_system, "tags", [])

program_paths = enabled_programs |> Enum.map(fn p -> Path.join([".", p]) end)
program_contents = enabled_programs |> Enum.map(fn p -> Path.join([".", p, "**"]) |> Path.wildcard(match_dot: true) end)

if not File.exists?("build") do
  File.mkdir!("build")
end

# for each program
enabled_programs
|> Enum.map(fn program ->
  File.mkdir_p!(Path.join([".", "build", program]))
  banned_dirs = (get_in(programs, [program, "stowignore"]) || []) |> MapSet.new()
  files_to_copy = Path.join([".", program, "**"])
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

  files_to_process = files
    |> Enum.map(fn old_path ->
      new_path = new_path_factory.(old_path)
      File.cp!(old_path, new_path)
      new_path
    end)
end)
# |> IO.inspect
# 1. we want to make sure it's not in the blacklist
# 2. create a corresponding directory in build/
# 3. copy the file
