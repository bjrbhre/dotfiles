###########################################################################
#                            Bash config file                            ##
###########################################################################
# Sourcing env files in appropriate order:
# 0 - aliases and functions
# 1 - platform-specific variables
# 2 - user-specific variables
# 3 - config (uses user.env and platform.env)
# 4 - private env files
ENV_DIR=$HOME/env
ENV_FILES="$ENV_DIR/bash_aliases \
           $ENV_DIR/platform.env \
           $ENV_DIR/user.env \
           $ENV_DIR/config.env"
[ -d $ENV_DIR/private ] && ENV_FILES="$ENV_FILES $(ls $ENV_DIR/private/*.env)"
for f in $ENV_FILES;do [ -r $f ] && source $f;done

###########################################################################
#                            Bash  settings                              ##
###########################################################################
# How many times EOF / ctrl-D is ignored before shell is closed
IGNOREEOF=1

# Shell options (type `shopt` to list all settable options)
shopt -s histappend # History on several terminals
