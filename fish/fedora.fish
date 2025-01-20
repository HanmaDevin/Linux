oh-my-posh init fish --config $HOME/.poshthemes/jandedobbeleer.omp.json | source

if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting

zoxide init fish | source

fastfetch

# Helpful aliases
alias c='clear' # clear terminal
alias l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias cd="z"
alias refresh="source ~/.config/fish/config.fish"

# pacman
alias get="sudo pacman -S --noconfirm"
alias remove="sudo pacman -Rsc"
alias update="sudo pacman -Syu"

alias editfish="nvim ~/.config/fish/config.fish"

# visual
alias open="xdg-open"
alias cat='bat --theme "Dracula"'
alias bat='bat --theme "Dracula"'
alias q="exit"

# git
alias gp="git push"
alias ga="git add"
alias gs="git status"
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gpull="git pull"
alias lg="lazygit"


# Handy change dir shortcuts
alias ..='z ..'
alias ...='z ../..'
alias .3='z ../../..'
alias .4='z ../../../..'
alias .5='z ../../../../..'

# exit terminal
bind \cd exit

bind \co 'nvim $(fzf)'
bind \ce yazi
bind \cg lazygit

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'
