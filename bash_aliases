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
alias ls="ls -CFG"
alias ll="ls -l"
alias llh="ls -lh"
alias lla="ls -la"
alias lss="ls -hsS"
alias ml="ls -ltr"

alias xd='cd ..'
alias df="df -h"

alias md5sum='md5'

alias vi='vim'
alias gvim='gvim -rv'

alias h='history|grep'
alias igrep='grep -i'
alias sf="find . \( -name \*.cc -o -name \*.hh -o -name \*.java \) | xargs grep -Hn"
alias sfind="find . \( -name \*.cc -o -name \*.hh -o -name -o -name \*.java \)"
alias scount="sfind -exec cat {} \;|wc -l"

alias rsync_dir='rsync -rvnc'

function csv_header() {
	delim=$2
	if test -z $delim
	then
		delim=';'
	fi
	for t in $(head -n 1 $1 | sed "s:$delim: :g");do echo $t;done | nl
}

alias bc="bc -lq"

alias j='jobs'

# Different geometries for vnc
alias vnc="vncserver :$VNC_PORT -depth 16 -geometry $GEOMETRY -name QVIDKRO1"
alias vnck="vncserver -kill :$VNC_PORT"
alias vncsmall="vncserver :$VNC_PORT -depth 16 -geometry $GEOMETRY_SMALl -name QVIDKRO1"
alias vncbig="vncserver :$VNC_PORT -depth 16 -geometry $GEOMETRY_LARGE -name QVIDKRO1"
# Checking open vnc ports
alias vncports="ps -ef | grep vnc | cut -c 1-9,54-56 | sort +4 -t ':'"

# Finding big files or directories (for cleaning)
alias bigdirs='find . -type d -exec du {\} \; | sort -n'
alias bigfiles='find . -type f -exec du {\} \; | sort -n'
alias guilty='du --max-depth 1 . 2>/dev/null | sort -rn'

# List of reflected objects/methods
alias reflect='find . \( -name \*.cc -o -name \*.hh \) -exec grep "END_REFLECT_TEMPLATE_CLASS\|END_REFLECT_CLASS\|DECLARE_SETTINGS\|DECLARE_CONTEXT_SETTINGS" {\} \; | sed -e "s/\([A-Z _]*\)(\([A-Z a-z 0-9 _ ,]*\))/\1\t\2/g" | sed -e "s/END_REFLECT_//g" | sed -e "s/DECLARE_//g" | sort -n'
alias reflect_methods='find . \( -name \*.cc -o -name \*.hh \) -exec grep "BEGIN_REFLECT_TEMPLATE_CLASS\|BEGIN_REFLECT_CLASS\|METHOD\|END_" {\} \; | sed -e "s/\([A-Z _]*\)(\([A-Z a-z 0-9 _ ,]*\))/\1\t\2/g" | sed -e "s/BEGIN_REFLECT_//g" | sed -e "s/REFLECT_/\t/g" | sed -e "s/END_\([\t _ A-Z a-z 0-9 ,]*\)/END\1\n/g"'

# Checking if namespaces are well declared/closed
alias grep_namespaces='sfindg namespace |cut -d ':' -f 2 | sort | uniq -c'

# Cleaning a project
alias clean_project_dir='rm aclocal.m4  autom4te.cache/ config.* configure depcomp install install-sh ltmain.sh missing  Makefile.in src/Makefile.in'

alias vgrind='valgrind --tool=memcheck --leak-check=yes --show-reachable=yes -v'
alias doPurify='valgrind --tool=memcheck -v --log-file=memcheck.log --leak-check=full --leak-resolution=med --show-reachable=yes --error-limit=no'
alias cgrind='valgrind --tool=callgrind --dump-instr=yes --combine-dumps=yes --collect-jumps=yes --collect-systime=yes'

alias today='date +%Y-%m-%d'
function hopen {
	open "http://$1"
}

#alias ct='ctags -R -f TAGS -L ./to_parse --format=2 -h ".h.hh.hpp" --excmd=number --languages="C,C++" --sort=yes --fields=mksSi'

function cki {
	if test "xx" = "xx$1"
	then
		echo "needs an argument"
		exit 1
	fi
	cat /etc/passwd | cut -d ":" -f 1,5 | grep "$1"
}

function mysupercompile {
	jobs=06
	if test $# -ne 0
	then
		jobs=$1
	fi

	#clear

	( make -j $jobs 2>/dev/null ) |sed -n "s/.* -o \(\w\+\).*/\1/p"
	echo make install
	make install
}

function ahead {
	acat $1 | head
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
#                             MongoDB/MongoHQ                            ##
###########################################################################

alias md='mongod -f ~/.mongod.conf'

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
