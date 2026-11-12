{ pkgs, lib, ... }:

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
      '' + lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '' + ''
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
        # Override Pure's VCS segment: show jj status in jj repos, git otherwise.
        # Shadows the plugin's vendor function since user functions load first.
        _pure_prompt_git = ''
          if set --query pure_enable_git; and test "$pure_enable_git" != true
            return
          end

          if type -q --no-functions jj
            # --ignore-working-copy: don't snapshot on every prompt (fast, no
            # op-log noise); dirty state refreshes after your next jj command.
            set --local jj_info (command jj log -r @ --no-graph --ignore-working-copy --color never \
              -T 'separate(" ", change_id.shortest(), coalesce(local_bookmarks.join(" "), parents.map(|p| p.local_bookmarks().join(" ")).join(" ")), if(conflict, "conflict"), if(divergent, "divergent")) ++ "\t" ++ if(empty, "", "dirty")' 2>/dev/null)
            if test $status -eq 0; and test -n "$jj_info"
              set --local parts (string split \t -- $jj_info)
              set --local branch_color (_pure_set_color $pure_color_git_branch)
              set --local out "$branch_color$parts[1]"
              if test "$parts[2]" = dirty
                set --local dirty_color (_pure_set_color $pure_color_git_dirty)
                set out "$out$dirty_color$pure_symbol_git_dirty"
              end
              echo "$out"
              return
            end
          end

          if not type -q --no-functions git
            return 2
          end

          if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
            set --local git_prompt (_pure_prompt_git_branch)(_pure_prompt_git_dirty)(_pure_prompt_git_stash)
            set --local git_pending_commits (_pure_prompt_git_pending_commits)
            if test (_pure_string_width $git_pending_commits) -ne 0
              set --append git_prompt $git_pending_commits
            end
            echo $git_prompt
          end
        '';
        gsize = ''
          set -f branch $argv[1]
          git diff --shortstat --color $branch | cat
        '';
      };
  };
}
