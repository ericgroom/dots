#tags (brewopt)
eval "$(/opt/homebrew/bin/brew shellenv)"
#end
#tags (brewusr)
eval "$(/usr/local/bin/brew shellenv)"
#end
eval "$(mise activate fish)"
fish_add_path ~/bin
set -gx EDITOR nvim
set -gx GIT_EDITOR nvim
if status is-interactive
    # Commands to run in interactive sessions can go here

    alias nota="cd ~/dev/Notability/"

    # git
    alias g="nvim -c 'Git | wincmd o' ."
    alias gs="git status"
    alias gco="git checkout"
    alias gl="git log --oneline"
    alias gcb="git checkout -b"
    alias gbl="git branch | cat"
    alias gbd="git branch -d"
    alias gc="git for-each-ref --format='%(refname:short)' refs/heads | fzf | xargs git checkout"
    alias gb="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
    alias ga="git ls-files --modified | fzf -m | xargs git add"
    alias gct="git --no-pager tag --list | fzf | xargs git checkout"

    function c
      set -f dir (fd -t d | fzf)
      cd $dir
    end

    function gsize
      set -f branch $argv[1]
      git diff --shortstat --color $branch | cat
    end
end
