###########################################################################
#                               Aliases                                  ##
###########################################################################

# Quick edit/sourcing of bashrc
alias vbashrc='vi $HOME/.bashrc'
alias s="source $HOME/.bashrc"

# secure file manipulation
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# listing files
alias ls="ls --color"
alias ll="ls -l"
alias llh="ls -lh"
alias lla="ls -la"
alias lss="ls -hsS"
alias ml="ls -ltr"

# VNC
alias vnc="vncserver :$VNC_PORT -depth 16 -geometry $VNC_GEOMETRY" #-name $VNC_NAME"
alias vnck="vncserver -kill :$VNC_PORT"
# Checking open vnc ports
alias vncports="ps -ef | grep vnc | cut -c 1-9,54-56 | sort +4 -t ':'"

# Finding big files or directories (for cleaning)
alias bigdirs='find . -type d -exec du {\} \; | sort -n'
alias bigfiles='find . -type f -exec du {\} \; | sort -n'
alias guilty='du --max-depth 1 . 2>/dev/null | sort -rn'

# Valgrind
alias vgrind='valgrind --tool=memcheck --leak-check=yes --show-reachable=yes -v'
alias doPurify='valgrind --tool=memcheck -v --log-file=memcheck.log --leak-check=full --leak-resolution=med --show-reachable=yes --error-limit=no'
alias cgrind='valgrind --tool=callgrind --dump-instr=yes --combine-dumps=yes --collect-jumps=yes --collect-systime=yes'

# Miscellaneous tricks and shortcuts
alias xd='cd ..'
alias df="df -h"
alias vi='vim'
# date with YYYY-MM-DD format
alias today='date +%Y-%m-%d'
alias h='history|grep'
# case insensitive grep
alias igrep='grep -i'
alias rsync_dir='rsync -rvnc'
alias bc="bc -lq"
alias j='jobs'

# Darwin specific
if [ "$(uname)" = "Darwin" ];then
	alias ls="ls -CFG"
	alias md5sum='md5'
fi

###########################################################################
#                               FUNCTIONS                                ##
###########################################################################
function csv_header() {
	delim=$2
	[ ! -z "$delim" ] || delim=';'
	for t in $(head -n 1 $1 | sed "s:$delim: :g");do echo $t;done | nl
}

function hopen {
	open "http://$1"
}

###########################################################################
#                             Git specific                               ##
###########################################################################
alias gb='git branch'
alias gba='git branch -a'
alias gst='git status'
alias gd='git diff'
alias gf='git fetch'
alias gc='git commit -v'
alias gp='git push'
alias gk='gitk --all 2>/dev/null'
alias gx='gitx --all 2>/dev/null'
alias gr='git remote -v'
alias git-branch='git branch --no-color 2>/dev/null | grep "^*" | sed -e "s/^[* ] \(.*\)/\1/g"'
alias git-tag='git describe --tags'

function parse_git_branch_and_add_brackets {
  #git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.\)/\[\1\]/'
  branch=$(git-branch 2>/dev/null)
  tag=$(git-tag --always 2>/dev/null)
  if test "x" != "x$branch"
  then
  	echo "[${branch}][${tag}]"
  fi
}

###########################################################################
#                                 MongoDB                                ##
###########################################################################
# md = mongod with overwritten dbpath using MONGO_DBPATH env variable
function md {
	[ ! -z "$MONGO_DBPATH" ] && mongod --dbpath $MONGO_DBPATH $@ || mongod $@
}

function mongo_wrapper {
	url=$1
	credentials=$(echo $url | cut -d '@' -f 1 | cut -d '/' -f 3)
	user=$(echo $credentials | cut -d ':' -f 1)
	password=$(echo $credentials | cut -d ':' -f 2-)
	address=$(echo $url | cut -d '@' -f 2)
	echo "[$0] connecting to [$address] with user [$user]"
	mongo -u $user -p $password $address
}

function mongoexport_wrapper {
	url=$1
	shift

	credentials=$(echo $url | cut -d '@' -f 1 | cut -d '/' -f 3)
	user=$(echo $credentials | cut -d ':' -f 1)
	password=$(echo $credentials | cut -d ':' -f 2-)
	address=$(echo $url | cut -d '@' -f 2)
	host=$(echo $address | cut -d '/' -f -1)
	db=$(echo $address | cut -d '/' -f 2-)
	echo "[$0] exporting from [$address] with user [$user]"
	mongoexport -u $user -p $password \
		--host $host \
		--db $db \
		$@
}

function mongodump_wrapper {
	url=$1
	shift

	credentials=$(echo $url | cut -d '@' -f 1 | cut -d '/' -f 3)
	user=$(echo $credentials | cut -d ':' -f 1)
	password=$(echo $credentials | cut -d ':' -f 2-)
	address=$(echo $url | cut -d '@' -f 2)
	host=$(echo $address | cut -d '/' -f -1)
	db=$(echo $address | cut -d '/' -f 2-)
	echo "[$0] exporting from [$address] with user [$user]"
	mongodump -u $user -p $password \
		--host $host \
		--db $db \
		$@
}

function mongorestore_wrapper {
	url=$1
	shift

	credentials=$(echo $url | cut -d '@' -f 1 | cut -d '/' -f 3)
	user=$(echo $credentials | cut -d ':' -f 1)
	password=$(echo $credentials | cut -d ':' -f 2-)
	address=$(echo $url | cut -d '@' -f 2)
	host=$(echo $address | cut -d '/' -f -1)
	db=$(echo $address | cut -d '/' -f 2-)
	echo "[$0] exporting from [$address] with user [$user]"
	mongorestore -u $user -p $password \
		--host $host \
		--db $db \
		$@
}

function redis_wrapper {
	url=$1
	credentials=$(echo $url | cut -d '@' -f 1 | cut -d '/' -f 3)
	user=$(echo $credentials | cut -d ':' -f 1)
	password=$(echo $credentials | cut -d ':' -f 2-)
	address=$(echo $url | cut -d '@' -f 2)
	host=$(echo $address | cut -d ':' -f 1)
	port=$(echo $address | cut -d ':' -f 2-)
	echo "[$0] connecting to [$address] with user [$user]"
	redis-cli -h $host -p $port -a $password
}

###########################################################################
#                             Heroku specific                            ##
###########################################################################
alias hrake='heroku run bundle exec rake'

###########################################################################
#                             PLSQL Connection                           ##
###########################################################################
alias PSQL='PGPASSWORD=$DWH_PASSWORD psql -h $DWH_HOST -U $DWH_USERNAME -p $DWH_PORT -d $DWH_DB'
