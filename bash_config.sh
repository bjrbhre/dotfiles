# bash-specific config
if [ $USER != "root" ]
then
	PS1='\[\033[1;30m\](\[\033[1;32m\]\u\[\033[1;30m\]@\[\033[0;36m\]\h\[\033[1;30m\])*(\[\033[0;36m\]\A\[\033[1;30m\])*(\[\033[0;36m\]\j\[\033[1;30m\])(\[\033[0;36m\]\w$(parse_git_branch_and_add_brackets)\[\033[1;30m\])\n\[\033[1;30m\](\[\033[0;36m\]$\[\033[1;30m\])\[\033[0m\]'
else
	PS1='\[\033[1;30m\](\[\033[1;31m\]\u\[\033[1;30m\]@\[\033[0;36m\]\h\[\033[1;30m\])*(\[\033[0;36m\]\A\[\033[1;30m\])*(\[\033[0;36m\]\j\[\033[1;30m\])(\[\033[0;36m\]\w\[\033[1;30m\])\n\[\033[1;30m\](\[\033[0;36m\]$\[\033[1;30m\])\[\033[0m\]'
fi
export PS1
export LS_COLORS=
# Shell options (bash: type `shopt` to list all settable options)
shopt -s histappend # History on several terminals
