eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(mise activate fish)"
fish_add_path ~/bin
if status is-interactive
    # Commands to run in interactive sessions can go here

    alias nota="cd ~/dev/Notability/"
    alias zsource="source ~/.zshrc"
    alias zedit="$EDITOR ~/.zshrc"

    # git
    alias g="nvim -c 'Git | wincmd o' ."
    alias gs="git status"
    alias gco="git checkout"
    alias gl="git log --oneline"
    alias gcb="git checkout -b"
    alias gcm="git commit -m"
    alias gbl="git branch | cat"
    alias gbd="git branch -d"
    alias gcam="git commit -am"
    alias girb="git rebase -i HEAD~10"
    alias gc="git for-each-ref --format='%(refname:short)' refs/heads | fzf | xargs git checkout"
    alias gb="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
    alias ga="git ls-files --modified | fzf -m | xargs git add"
    alias gd="git ls-files --modified | fzf | xargs git diff"
    alias gct="git --no-pager tag --list | fzf | xargs git checkout"
    alias gsize="git diff --stat --color master | cat"
end
