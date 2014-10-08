#! /usr/bin/env sh

#======= SETTINGS =======#
DOTFILES_REPO=https://github.com/bjrbhre/dotfiles.git
DOTFILES=$HOME/.dotfiles
SSH_KEY=$HOME/.ssh/id_rsa
#==== END OF SETTINGS ===#

set -e

#======== HELPERS =======#
fancy_echo() {
  printf "%b" "$1"
}

test_command() {
  type $1 1>/dev/null 2>&1 || { echo >&2 "No such file [ $1 ]"; exit 1; }
}
#=======================#

# 1. sytem update
fancy_echo "Updating system software...\n"
if [ "$(uname)" = "Darwin" ];then
  sudo softwareupdate --install --all
else
  sudo apt-get update -y
fi

# 2. clone and link dotfiles
test_command git
fancy_echo "Checking dotfiles directory [ $DOTFILES ]..."
[ -d $DOTFILES ] && echo "OK" || git clone $DOTFILES_REPO $DOTFILES
fancy_echo "Linking dotfiles... "
[ -x $DOTFILES/link.sh ] && $DOTFILES/link.sh && echo "OK"

# 3. install software using laptop.sh
if [ "$(uname)" = "Darwin" ];then
  bash <(curl -s https://raw.githubusercontent.com/thoughtbot/laptop/master/mac) 2>&1 | tee ~/laptop.log
else
  bash <(wget -qO- https://raw.githubusercontent.com/thoughtbot/laptop/master/linux) 2>&1 | tee ~/laptop.log
fi

# generate SSH_KEY (and source user.env to set $EMAIL)
[ -f $DOTFILES/user.env ] && source $DOTFILES/user.env
fancy_echo "Checking ssh key [ $SSH_KEY ]... "
[ -f $SSH_KEY ] && echo "OK" || ssh-keygen -f $SSH_KEY -N "" -C "$EMAIL"

