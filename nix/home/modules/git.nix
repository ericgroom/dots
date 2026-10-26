{ pkgs, ... }:
{
  programs.gh.enable = true;
  programs.jujutsu.enable = true;
  programs.jjui = {
    enable = true;
    settings.actions = [
      {
        name = "open file in nvim";
        desc = "open in nvim";
        key = "e";
        scope = "revisions.details";
        lua = ''
          local file = context.file()
          if file == nil then return end
          local root = (jj("root") or ""):gsub("%s+$", "")
          local path = root .. "/" .. file
          local function shq(s) return "'" .. s:gsub("'", [['"'"']]) .. "'" end
          local server = os.getenv("NVIM")
          if server then
            -- running inside a nvim :terminal, open in the parent instance
            -- (vimscript escapes ' by doubling it)
            local q = string.rep("'", 2)
            local expr = "v:lua.jjui_open('" .. path:gsub("'", q) .. "')"
            exec_shell("nvim --server " .. shq(server) .. " --remote-expr " .. shq(expr) .. " >/dev/null")
          else
            exec_shell("nvim " .. shq(path))
          end
        '';
      }
    ];
  };
  # Start with a simple git configuration (email configured manually per system)
  programs.git = {
    enable = true;
    settings.user.name = "Eric Groom";
  };
}
