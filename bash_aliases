###########################################################################
#                               Aliases                                  ##
###########################################################################

# Quick edit/sourcing of bashrc
alias vbashrc='vi $HOME/.bashrc'
alias s="source $HOME/.bashrc"
[ "x$BASH_VERSION" != "x" ] && alias s='source $HOME/.bashrc'
[ "x$ZSH_VERSION" != "x" ]  && alias s='source $HOME/.zshrc'

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

# Make
alias m='make'

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

# python
alias venv='source venv/bin/activate'

# ruby
alias be='bundle exec'

# chrome
alias chr='open -a Google\ Chrome --args --disable-web-security'

# Darwin specific
if [ "$(uname)" = "Darwin" ];then
	alias ls="ls -CFG"
	# alias md5sum='md5'
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

fancy_echo() {
  printf "%b" "$1"
}

function shrink_pdf {
  input=$1
  output=$2
  if [ -z "$output" ]; then output='-';fi

  gs \
    -sDEVICE=pdfwrite \
    -dCompatibilityLevel=1.4 \
    -dPDFSETTINGS=/ebook \
    -dNOPAUSE \
    -dQUIET \
    -dBATCH \
    -sOutputFile=$output \
    $input
}

test_command() {
  type $1 1>/dev/null 2>&1 || { echo >&2 "No such file [ $1 ]"; exit 1; }
}

line_sep() { cat << EOF
------------------------------------------------------------
EOF
}

# demo = cat file before execution
demo() {
	line_sep
	cat $1
	line_sep
	if [ -x $1 ];then
    echo -n "Execute file? (y/n)..."
    read REPLY # does it work for bash?
    [[ $REPLY =~ ^[Yy]$ ]] && $@ || echo "exit"
	else
		echo "file not executable [$1]"
	fi
}

###########################################################################
#                           Docker specific                              ##
###########################################################################
drm() { docker rm $(docker ps -q -a); }
dri() { docker rmi $(docker images -q); }
alias dps='docker ps -a'
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias db='docker build -t $(repo) .'
alias dr='docker run --rm -t -i $(repo)'

###########################################################################
#                             Git specific                               ##
###########################################################################
alias repo='echo "$GITHUB_USERNAME/$(basename $(pwd))"'
alias gb='git branch'
alias gba='git branch -a'
alias gst='git status'
alias gd='git diff'
alias gf='git fetch'
alias gc='git commit -v'
alias gp='git push'
# gitk issue: see [here](http://comments.gmane.org/gmane.comp.version-control.git/278820)
# alias gk='gitk --all 2>/dev/null'
alias gk='LANG=C gitk --all 2>/dev/null'
alias gt='LANG=C gitk --all 2>/dev/null'
alias gx='gitx --all 2>/dev/null'
alias gr='git remote -v'
alias git-branch='git branch --no-color 2>/dev/null | grep "^*" | sed -e "s/^[* ] \(.*\)/\1/g"'
alias git-tag='git describe --tags'
alias gfa='for r in $(git remote);do git fetch -v -p $r;done'
alias gfa_and_tree='for d in $(find . -type d -maxdepth 1 |grep -v "^.$");do echo "========== $d";cd $d;gfa;gt&;cd -;done'
alias ghb='open https://github.com/$(git remote get-url origin |cut -d ":" -f 2|sed -e "s:\.git:/branches/all:g")'

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
#                                 GitHub                                ##
###########################################################################
function gh_api {
  GITHUB_API_URL='https://api.github.com'
  curl -H "Authorization: token $GITHUB_TOKEN" \
    "$GITHUB_API_URL$@"
}

function gh_count_issues {
  repo=$1
  labels=$2

  GITHUB_API_URL='https://api.github.com'
  curl -H "Authorization: token $GITHUB_TOKEN" \
    "$GITHUB_API_URL/repos/$repo/issues?page=1&per_page=100&state=open&labels=$labels" \
    2>/dev/null \
    | jq '. | length'
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
  shift

	credentials=$(echo $url | cut -d '@' -f 1 | cut -d '/' -f 3)
	user=$(echo $credentials | cut -d ':' -f 1)
	password=$(echo $credentials | cut -d ':' -f 2-)
	address=$(echo $url | cut -d '@' -f 2)
	echo "[$0] connecting to [$address] with user [$user]"
	mongo -u $user -p $password $address $@
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

function mongoimport_wrapper {
	url=$1
	shift

	credentials=$(echo $url | cut -d '@' -f 1 | cut -d '/' -f 3)
	user=$(echo $credentials | cut -d ':' -f 1)
	password=$(echo $credentials | cut -d ':' -f 2-)
	address=$(echo $url | cut -d '@' -f 2)
	host=$(echo $address | cut -d '/' -f -1)
	db=$(echo $address | cut -d '/' -f 2-)
	echo "[$0] exporting from [$address] with user [$user]"
	mongoimport -u $user -p $password \
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

function psql_wrapper {
	url=$1
  shift

	credentials=$(echo $url | cut -d '@' -f 1 | cut -d '/' -f 3)
	user=$(echo $credentials | cut -d ':' -f 1)
	password=$(echo $credentials | cut -d ':' -f 2-)
	address=$(echo $url | cut -d '@' -f 2)
	host=$(echo $address | cut -d ':' -f 1)
	port_and_db=$(echo $address | cut -d ':' -f 2-)
  port=$(echo $port_and_db | cut -d '/' -f 1)
  db=$(echo $port_and_db | cut -d '/' -f 2)
	echo "[$0] connecting to [$address] with user [$user]"
	PGPASSWORD=$password psql -h $host -p $port -U $user -d $db $@
}

###########################################################################
#                             Heroku specific                            ##
###########################################################################
alias brake='bundle exec rake'
alias hrake='heroku run bundle exec rake'

###########################################################################
#                             PLSQL Connection                           ##
###########################################################################
alias PSQL='PGPASSWORD=$DWH_PASSWORD psql -h $DWH_HOST -U $DWH_USERNAME -p $DWH_PORT -d $DWH_DB'
alias MSSQL='$(npm bin)/mssql -u "$MSSQL_USER" -p "$MSSQL_PASSWORD" -o "$MSSQL_PORT" -s "$MSSQL_SERVER"'
