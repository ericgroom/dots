{ pkgs, ... }:

{
  # Fish shell configuration
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "pure";
        src = pkgs.fishPlugins.pure;
      }
    ];
      shellInit = ''
        eval "$(mise activate fish)"
        fish_add_path ~/bin
        set -gx EDITOR nvim
        set -gx GIT_EDITOR nvim
      '';
      shellAliases = {
        # Git aliases
        g = "nvim -c 'Git | wincmd o' .";
        gs = "git status";
        gco = "git checkout";
        gl = "git log --oneline";
        gcb = "git checkout -b";
        gbl = "git branch | cat";
        gbd = "git branch -d";
        gc = "git for-each-ref --format='%(refname:short)' refs/heads | fzf | xargs git checkout";
        gb = "git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'";
        ga = "git ls-files --modified | fzf -m | xargs git add";
        gct = "git --no-pager tag --list | fzf | xargs git checkout";
      };
      functions = {
        c = ''
          set -f dir (fd -t d | fzf)
          cd $dir
        '';
        gsize = ''
          set -f branch $argv[1]
          git diff --shortstat --color $branch | cat
        '';
      };
  };
}
