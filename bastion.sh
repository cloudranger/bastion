#!/usr/bin/env bash
#set -o errexit

# Check bashtools is installed
#TODO

# Check bastille is installed
#TODO

# shellcheck disable=SC1091 # (info): Not following: script> was not specified as input (see shellcheck -x).
source /usr/local/bin/bashtools/user.sh

# shellcheck disable=SC1091 # (info): Not following: script> was not specified as input (see shellcheck -x).
source /usr/local/bin/bashtools/msg.sh



################################################################################
################################################################################

#_set_() {
#  #shellcheck disable=SC3043 # In posix, local is undefined
#  local key="$1"
#  local val="$2"
#
#  hashmap::put _bastion_ "${key}" "${val}"
#}


function _quit_no_jail_() {
  if [ -z "${BASTION_JAIL}" ]; then
    msg::short "jail not set - use JAIL command to set your jail name"
    exit 1
  fi
}

################################################################################
################################################################################

function _run_() 
{
  user::exit_not_root

  msg::line
  msg::short "$*"
  msg::line

  eval "$*"

   #SET STATUS $?
   #local verbose
#   local cmd
   #local status

#TODO
#   if (( LXDTOOLS_VAR[VERBOSE] == 1 )); then
#      verbose="-v"
#   else
#      verbose=""
#   fi

#   cmd="${LXDTOOLS_KEYWORD[${func}]}"

#   for P in "$@"
#   do
#      if [[ "${P}" == *" "* ]]; then
#         P="\"${P}\""
#      fi
#      cmd="$cmd $P"
#   done
#
   #local CMD="${LXDTOOLS_KEYWORD[${FUNC}]} ${VERBOSE} ${PARAMS}"
   #local CMD="${LXDTOOLS_KEYWORD[${FUNC}]} ${PARAMS}"
   #_log_ 0 "${FUNC}" "${FUNC} ${@}"

#   _log_ 3 "${func} ${cmd}"

#   eval "${cmd}"
#   LXDTOOLS_VAR[STATUS]=$?

#   _log_ 2 "${func} Status: ${LXDTOOLS_VAR[STATUS]}"
}



################################################################################
#  _                                                                  
# | |__   __ _ ___  ___     __      ___ __ __ _ _ __  _ __   ___ _ __ 
# | '_ \ / _` / __|/ _ \____\ \ /\ / / '__/ _` | '_ \| '_ \ / _ \ '__|
# | |_) | (_| \__ \  __/_____\ V  V /| | | (_| | |_) | |_) |  __/ |   
# |_.__/ \__,_|___/\___|      \_/\_/ |_|  \__,_| .__/| .__/ \___|_|   
#                                              |_|   |_|              
#
# Wrapper for executing all commands that don't take any consistent parameters
################################################################################

function _base_wrapper_() 
{
  user::exit_not_root

  #shellcheck disable=SC3043 # In posix, local is undefined
  local cmd="$1"
  shift
  
  _run_ bastille "${cmd}" "$*"
}

################################################################################
#    _       _ _                                               
#   (_) __ _(_) |    __      ___ __ __ _ _ __  _ __   ___ _ __ 
#   | |/ _` | | |____\ \ /\ / / '__/ _` | '_ \| '_ \ / _ \ '__|
#   | | (_| | | |_____\ V  V /| | | (_| | |_) | |_) |  __/ |   
#  _/ |\__,_|_|_|      \_/\_/ |_|  \__,_| .__/| .__/ \___|_|   
# |__/                                  |_|   |_|              
#
# Wrapper for executing all commands that take the jail name as the first param
################################################################################

function _jail_wrapper_() 
{
  user::exit_not_root
  _quit_no_jail_

  local -r cmd="$1"
  shift

  _run_ bastille "${cmd}" "${BASTION_JAIL}" "$*"
}



################################################################################
# Custom workaround for create
# It puts the jail after some options but before others so we have to separate
# the - or -- options from the rest and put them in the correct place in the 
# final call
################################################################################

function CREATE()
{
  user::exit_not_root
  _quit_no_jail_

  #shellcheck disable=SC3043 # In posix, local is undefined
  local params=$*

  #shellcheck disable=SC3043 # In posix, local is undefined
  local opts=""

  #shellcheck disable=SC3043 # In posix, local is undefined
  local other=""

  # Split out the - and -- options from the others
  for p in $params
  do
    echo "$p"
    opt=$(echo "$p" | grep "^-")
    if [ -n "${opt}" ]; then
      opts="$opts $p"
    else
      other="$other $p"
    fi
  done

  _run_ bastille "create" "${opts}" "${BASTION_JAIL}" "${other}"
}


#
# Custom commands we add to the bastille commands


################################################################################

/usr/local/bin/bash: line 1: figlet: command not found
################################################################################

function CONFIG()
{
  user::exit_not_root

  #shellcheck disable=SC3043 # In posix, local is undefined
  local -r config="$1"

  if [[ ! -f "${config}" -o ! -r "${config}" ]]; then
    msg::short "Config file not found or not readable: ${config}"
    exit 1
  fi

  source "${config}"
}



################################################################################
#    _       _ _ 
#   (_) __ _(_) |
#   | |/ _` | | |
#   | | (_| | | |
#  _/ |\__,_|_|_|
# |__/           
#
# Set the environment variable for the active jail
# This variable will be used in all commands that require the jail name
# so that you don't have to supply it every time
################################################################################

function JAIL()
{
  user::exit_not_root

  #shellcheck disable=SC3043 # In posix, local is undefined
  local jailname="$1"

  BASTION_JAIL="${jailname}"
}


################################################################################
################################################################################

#SET() {
#  #shellcheck disable=SC3043 # In posix, local is undefined
#  local key="$1"
#  
#  #shellcheck disable=SC3043 # In posix, local is undefined
#  local val="$2"
#
#  hashmap::put ${HASHMAP} "${key}" "${val}"
#}


################################################################################
################################################################################

#GET() {
#   local key="$1"
#
#   hashmap::get ${HASHMAP} "${key}"
#}


################################################################################
#                                   _ 
#   __ _ _ __  _ __   ___ _ __   __| |
#  / _` | '_ \| '_ \ / _ \ '_ \ / _` |
# | (_| | |_) | |_) |  __/ | | | (_| |
#  \__,_| .__/| .__/ \___|_| |_|\__,_|
#      |_|   |_|                     
#
#  Append a line to the end of a file
#  Normally used to write config to a file
################################################################################

function APPEND()
{
  user::exit_not_root

  #shellcheck disable=SC3043 # In posix, local is undefined
  local file="$1"

  #shellcheck disable=SC3043 # In posix, local is undefined
  local text="$2"


  echo "${text}" | CMD tee -a "${file}"
}

################################################################################
################################################################################

function PACKAGE()
{
  #echo "$FUNCNAME $*"
  user::exit_not_root
  _quit_no_jail_

  #shellcheck disable=SC3043 # In posix, local is undefined
  local -r action="$1"
  shift 

  _run_ bastille pkg "${BASTION_JAIL}" "${action}" -y "$*"
}


################################################################################

function BANNER()
{
  local -r msg="$1"
  msg::line
  figlet "${msg}"
  msg::line
}


################################################################################

function COMMENT()
{
  local -r msg="$1"
  echo "# ${msg}"

}

################################################################################

function LINE()
{
  msg::line
}


################################################################################
#            _ _   
#   _____  _(_) |_ 
#  / _ \ \/ / | __|
# |  __/>  <| | |_ 
#  \___/_/\_\_|\__|
#
################################################################################

function EXIT()
{
  #shellcheck disable=SC3043 # In posix, local is undefined
  local status="$1"

  exit "${status}"
}


################################################################################
# MAIN
################################################################################

#readonly HASHMAP=$(hashmap::create _bastion_)
BASTION_JAIL=""

#SET DEBUG 0
#SET LOGLEVEL 3
#SET LOG_PRINT_TIMESTAMP 1
#SET LOG_PRINT_LOGLEVEL 0

echo "${BASH_SOURCE[0]}"

################################################################################
# COMMAND FUNCTIONS
################################################################################


################################################################################
#        _ _                     
#   __ _| (_) __ _ ___  ___  ___ 
#  / _` | | |/ _` / __|/ _ \/ __|
# | (_| | | | (_| \__ \  __/\__ \
#  \__,_|_|_|\__,_|___/\___||___/
#                                
# Aliases for basic bastille commands
################################################################################

# Bastille commands which consistently take a jail name as their first parameter
function CLONE() 	{ _jail_wrapper_ "clone" "$*"; }
function CMD() 		{ _jail_wrapper_ "cmd" "$*"; }
function CONFIG() 	{ _jail_wrapper_ "config" "$*"; }
function CONVERT() 	{ _jail_wrapper_ "convert" "$*"; }
function CP() 		{ _jail_wrapper_ "cp" "$*"; }
function DESTROY() 	{ _jail_wrapper_ "destroy" "$*"; }
function EXPORT() 	{ _jail_wrapper_ "export" "$*"; }
function MOUNT() 	{ _jail_wrapper_ "mount" "$*"; }
function PKG() 		{ _jail_wrapper_ "pkg" "$*"; }
function RDR() 		{ _jail_wrapper_ "rdr" "$*"; }
function RENAME() 	{ _jail_wrapper_ "rename" "$*"; }
function RESTART() 	{ _jail_wrapper_ "restart" "$*"; }
function SERVICE() 	{ _jail_wrapper_ "service" "$*"; }
function START() 	{ _jail_wrapper_ "start" "$*"; }
function STOP() 	{ _jail_wrapper_ "stop" "$*"; }
function SYSRC() 	{ _jail_wrapper_ "sysrc" "$*"; }
function UNMOUNT() 	{ _jail_wrapper_ "unmount" "$*"; }


# Bastille commands which do not take a jail name as their first parameter
function LIST() 	{ _base_wrapper_ "list" "$*"; }
function BOOTSTRAP() 	{ _base_wrapper_ "bootstrap" "$*"; }
function IMPORT() 	{ _base_wrapper_ "import" "$*"; }
function RCP() 		{ _base_wrapper_ "rcp" "$*"; }
function SETUP() 	{ _base_wrapper_ "setup" "$*"; }
function TAGS() 	{ _base_wrapper_ "tags" "$*"; }
function UPDATE() 	{ _base_wrapper_ "update" "$*"; }
function UPGRADE() 	{ _base_wrapper_ "upgrade" "$*"; }
function VERIFY() 	{ _base_wrapper_ "verify" "$*"; }
function ZFS() 		{ _base_wrapper_ "zfs" "$*"; }

# Custom aliases for people who like other flavours of commands
# For instance for people coming from the Docker world

#function EXEC()		{ CMD $* }
#alias HOST="exec $@"


