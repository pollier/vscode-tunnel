# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
	git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export HOMEBREW_NO_ENV_HINTS=true
export ZSH="$HOME/.oh-my-zsh"
PATH="$PATH:$HOME/.local/bin"
DISABLE_UNTRACKED_FILES_DIRTY="true"
ZSH_THEME="powerlevel10k/powerlevel10k"

export DEBIAN_FRONTEND=noninteractive

HIST_STAMPS="dd/mm/yyyy"

fpath=($fpath ~/.zsh/completion)

FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

plugins=(
  autoswitch_virtualenv
  aws
  brew
  colored-man-pages
  command-not-found
  dirhistory
  docker
  docker-compose
  extract
  git
  git-auto-fetch
  gitignore
  gnu-utils
  golang
  gpg-agent
  helm
  history
  httpie
  microk8s
  nmap
  npm
  pip
  python
  rsync
  screen
  scw
  systemd
  terraform
  ubuntu
  ufw
  virtualenv
  vscode
  yarn
)

zstyle ':omz:plugins:*' aliases no
zstyle ':omz:plugins:microk8s' aliases yes
# zstyle ':omz:lib:*' aliases no

source $ZSH/oh-my-zsh.sh

if [ ! -d "$ZSH_CUSTOM/plugins/autoswitch_virtualenv" ]; then
  git clone "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git" "$ZSH_CUSTOM/plugins/autoswitch_virtualenv"
fi

if [ ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

alias apt-get="sudo apt-get"
alias apt="sudo apt"
alias gtcp="git add -A; git commit -m gtcp; git push"
alias gtree="git log --graph --decorate --all --oneline"
alias journalctl="sudo journalctl"
alias microk8s="sudo microk8s"
alias reboot="sudo reboot"
alias restart="sudo systemctl restart"
alias seedbox-restart="sudo systemctl restart nginx.service && systemctl restart qbittorrent-nox@seedbox.service && sudo systemctl restart php8.3-fpm.service"
alias rmrf="rm -Rf"
alias systemctl="sudo systemctl"
alias ufw="sudo ufw"
alias weather="curl wttr.in"
alias webserver="python3 -m http.server 9000"

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

export DOCKER_BUILDKIT=1
export BUILDKIT_PROGRESS=plain

# Scaleway CLI autocomplete initialization.

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

setopt SHARE_HISTORY
