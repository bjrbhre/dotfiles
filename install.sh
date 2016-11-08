#! /usr/bin/env bash

#======= SETTINGS =======#
OH_MY_ZSH_REPO=https://github.com/robbyrussell/oh-my-zsh.git
OH_MY_ZSH_DIR=$HOME/.oh-my-zsh
DOTFILES_REPO=https://github.com/bjrbhre/dotfiles.git
DOTFILES=$HOME/.dotfiles
SSH_KEY=$HOME/.ssh/id_rsa
#==== END OF SETTINGS ===#

#======== HELPERS =======#
fancy_echo() {
  printf "%b" "$1"
}

test_command() {
  type $1 1>/dev/null 2>&1 || { echo >&2 "No such file [ $1 ]"; exit 1; }
}
#=======================#

# set -e # error mode causes failure is there is no software update

# 1. sytem update
fancy_echo "Updating system software...\n"
if [ "$(uname)" = "Darwin" ];then
  sudo softwareupdate --install --all
else
  sudo apt-get update -y
fi
# 1.1 installing xcode command line tools
developer_dir=$(xcode-select -print-path 2>/dev/null)
if [ "x" = "x$developer_dir" ];then
  fancy_echo "Installing the Command Line Tools (expect a GUI popup)...\n"
  sudo xcode-select --install
  fancy_echo "Press any key when the installation has completed..."
  read text
else
  fancy_echo "Command Line Tools already installed.\n"
fi

# 2. clone and link dotfiles
test_command git
fancy_echo "Checking oh-my-zsh directory [ $OH_MY_ZSH_DIR ]..."
[ -d $OH_MY_ZSH_DIR ] && echo "OK" || git clone $OH_MY_ZSH_REPO $OH_MY_ZSH_DIR
fancy_echo "Checking dotfiles directory [ $DOTFILES ]..."
[ -d $DOTFILES ] && echo "OK" || git clone $DOTFILES_REPO $DOTFILES
fancy_echo "Linking dotfiles... "
[ -x $DOTFILES/link.sh ] && $DOTFILES/link.sh && echo "OK"

# 3. install software using laptop.sh
if [ "$(uname)" = "Darwin" ];then
  curl --remote-name "https://raw.githubusercontent.com/thoughtbot/laptop/master/mac"
  vi mac
  sh mac 2>&1 | tee ~/laptop.log
else
  bash <(wget -qO- "https://raw.githubusercontent.com/thoughtbot/laptop/master/linux") 2>&1 | tee ~/laptop.log
fi

# generate SSH_KEY (and source user.env to set $EMAIL)
[ -f $DOTFILES/user.env ] && source $DOTFILES/user.env
fancy_echo "Checking ssh key [ $SSH_KEY ]... "
[ -f $SSH_KEY ] && echo "OK" || ssh-keygen -f $SSH_KEY -N "" -C "$EMAIL"

SSH_PEM=$SSH_KEY.pub.pem
fancy_echo "Checking ssh public key [ $SSH_PEM ]... "
[ -f $SSH_PEM ] && echo "OK" || openssl rsa -in $SSH_KEY -pubout -out $SSH_PEM

