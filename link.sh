#! /usr/bin/env sh
env_dir=$(dirname $0)
dotfiles=" bashrc \
           bash_profile \
           gitconfig \
           gitignore_global \
           laptop.local \
           rspec \
           vimrc \
		   zshrc "

for file in $dotfiles;do
  ln -s $env_dir/$file $HOME/.${file}
done
