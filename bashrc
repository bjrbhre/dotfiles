###########################################################################
#                    The bashrc of the platform                          ##
###########################################################################
ENV_DIR=$HOME/env
test -e $ENV_DIR/bash_variables && source $ENV_DIR/bash_variables
test -e $ENV_DIR/bash_aliases && source $ENV_DIR/bash_aliases
###########################################################################

###########################################################################
#                         Standard  settings                             ##
###########################################################################
EDITOR=$GTK_DIR/bin/vim
XEDITOR=$GTK_DIR/bin/gvim
CVSEDITOR=$GTK_DIR/bin/vim
export EDITOR XEDITOR CVSEDITOR
# Action of interactive shell when EOF is the sole input
IGNOREEOF=1

# History on several terminals
shopt -s histappend
#ulimit -c unlimited

###########################################################################
#                             Terminal display                           ##
###########################################################################
# Layout of the shell command invite
if [ $USER != "root" ] 
then 
	PS1='\[\033[1;30m\](\[\033[1;32m\]\u\[\033[1;30m\]@\[\033[0;36m\]\h\[\033[1;30m\])*(\[\033[0;36m\]\A\[\033[1;30m\])*(\[\033[0;36m\]\j\[\033[1;30m\])(\[\033[0;36m\]\w$(parse_git_branch_and_add_brackets)\[\033[1;30m\])\n\[\033[1;30m\](\[\033[0;36m\]$\[\033[1;30m\])\[\033[0m\]'
else 
	PS1='\[\033[1;30m\](\[\033[1;31m\]\u\[\033[1;30m\]@\[\033[0;36m\]\h\[\033[1;30m\])*(\[\033[0;36m\]\A\[\033[1;30m\])*(\[\033[0;36m\]\j\[\033[1;30m\])(\[\033[0;36m\]\w\[\033[1;30m\])\n\[\033[1;30m\](\[\033[0;36m\]$\[\033[1;30m\])\[\033[0m\]'
fi
export PS1
export LS_COLORS=

export BREW_HOME="/usr/local"
export PATH=$BREW_HOME/bin:$PATH

export RVM_HOME="$HOME/.rvm"
export PATH=$RVM_HOME/bin:$PATH

if [[ -s $RVM_HOME/scripts/rvm ]]; then
	  source $RVM_HOME/scripts/rvm;
fi

export PATH=$HOME/bin:$PATH:$GOPATH/bin

