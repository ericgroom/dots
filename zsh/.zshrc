# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Lines configured by zsh-newuser-install
unsetopt beep
# End of lines configured by zsh-newuser-install
# export PATH=~/.gem/ruby/2.3.0/bin:$PATH
export PATH=~/bin/:~/.cargo/bin:~/.emacs.d/bin:$PATH

#aliases
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
alias ga="git ls-files --modified | fzf -m | xargs git add"
alias gd="git ls-files --modified | fzf | xargs git diff"
alias gct="git --no-pager tag --list | fzf | xargs git checkout"
alias gsize="git diff --stat --color master | cat"

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
prompt pure

#tags (asdfbrew)
. /usr/local/opt/asdf/libexec/asdf.sh
#end
#tags (asdfgit)
. $HOME/.asdf/asdf.sh
#end
#tags (asdfbrewopt)
. /opt/homebrew/opt/asdf/libexec/asdf.sh
#end
