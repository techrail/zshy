#!/usr/bin/env zsh

# kbackup:usage = kusg
# utils:array_search = asrch
# utils:array_elem_pos = gelposina
# utils:get_argument_value = garval

function kbackup:usage() {
  echo "----------------------------"
  echo "${(%):-%x} backs up kubernetes resource definitions in yaml"
  echo ""
  echo "Usage: "
  echo "${(%):-%x} --dir base_dir [other_options]"
  echo ""
  echo "base_dir is the full path of the directory where all the files have to be created"
  echo "        base_dir cannot be relative path."
  echo "        base_dir must not end with a '/'."
  echo "        base_dir is not required to exist beforehand."
  echo ""
  echo "other_options:"
  echo ""
  echo "--logfile logfile_location"
  echo "        logfile_location is the full file path where the logs are to be saved"
  echo "        logfile_location can be a full or relative path."
  echo "        logfile_location is not required to exist beforehand"
  echo "        When not supplied, STDOUT will be used for log output."
  echo "--namespaces namespace_list"
  echo "        namespace_list is a comma-separated (no spaces between commas) list of namespaces"
  echo "        e.g. default,test,kube-system,kube-public"
  echo "--resources resource_list"
  echo "        resource_list is a comma-separated (no spaces between commas) list of api-resources"
  echo "        e.g. pods,secrets,configmaps"
  echo ""
}

logfile_location="STDOUT"
  
function kb_log() {
  local curr_time
  curr_time=$(date '+%Y-%m-%d %H:%M:%S')
  if [[ "${logfile_location}" == "STDOUT" ]]; then
    echo "[${curr_time}]: $*"
  else
    echo "[${curr_time}]: $*" >> $logfile_location
  fi
}

function utils:array_search() {
  local needle
  needle=$1
  shift

  local array=($*)

  local i
  i=0

  for (( i = 1; i <= ${#array}; i++ )); do
    if [[ "$needle" == "${array[$i]}" ]]; then
      return 0
    fi
  done

  return 1
}

function utils:array_elem_pos() {
  local needle
  needle=$1
  shift

  local array=($*)

  local i
  i=0

  for (( i = 1; i <= ${#array}; i++ )); do
    if [[ "$needle" == "${array[$i]}" ]]; then
      return $i
    fi
  done
}

function utils:get_argument_value() {
  local arg_pos
  local val_pos

  # argument
  local needle
  needle=$1
  shift

  local array=($*)

  if utils:array_search $needle $array; then
    utils:array_elem_pos $needle $array
    arg_pos=$?
    ((val_pos = arg_pos + 1))
    print $array[val_pos]
    return 0
  fi

  print ""
  return 1
}

logfile_location=$(utils:get_argument_value '--logfile' $@)

if [ -z "$logfile_location" ]; then
  echo "--logfile argument was not supplied. Using STDOUT for logging messages"
  logfile_location="STDOUT"
else
  touch $logfile_location

  if [ $? -ne 0 ]; then
    echo "Cannot create or modify the logfile: $logfile_location."
    echo "Please ensure this script can create/modify the log file."
    echo "!!! Aborting !!!"
    exit 8
  fi
fi

kb_log "===>>>"
kb_log "Starting run"

kb_log "logfile_location = $logfile_location"

kb_log "Checking kubeconfig"
if [[ -v KUBECONFIG ]]; then
  kb_log "\$KUBECONFIG set to ${KUBECONFIG}"
  if [[ -f $KUBECONFIG ]]; then
    kb_log "kubeconfig file found at expected location"
  else
    kb_log "!!! kubeconfig file not found at expected location"
    kb_log "!!! Aborting !!!"
    exit 2
  fi
else
  kb_log "\$KUBECONFIG is not set."
  if [[ -f $HOME/.kube/config ]]; then
    kb_log "kubeconfig file found at $HOME/.kube/config"
  else
    kb_log "!!! kubeconfig file not found at expected default location ($HOME/.kube/config) "
    kb_log "!!! Aborting !!!"
    exit 3
  fi
fi

kb_log "Checking if kubectl is available..."
if ! type "kubectl" > /dev/null; then
  kb_log "kubectl not found in path."
  kb_log "!!! Aborting !!!"
  exit 4
else
  kb_log "kubectl found at $(type kubectl)"
fi

local base_dir
local -a namespaces
local -a resource_types

local arg_pos
local val_pos

base_dir=$(utils:get_argument_value '--dir' $@)

if [ -z "$base_dir" ]; then
  kb_log "--dir argument is required"
  kbackup:usage
  kb_log "See usage above"
  kb_log "!!! Aborting !!!"
  exit 5
else
  # Test that the base_dir starts with a '/'
  if [[ $base_dir != "/"* ]]; then 
    kbackup:usage
    kb_log "base_dir does not start with /"
    kb_log "See usage above"
    kb_log "!!! Aborting !!!"
    exit 6
  fi

  # Make the directory
  mkdir -p $base_dir

  if [ $? -ne 0 ]; then
    kb_log "Could not mkdir $base_dir"
    kb_log "!!! Aborting !!!"
    exit 7
  fi

  base_dir=$base_dir
  kb_log "base_dir = $base_dir"
fi

kb_log "Getting current context..."
kb_log "Current context: $(kubectl config current-context)"

local namespaces_input
namespaces_input=$(utils:get_argument_value '--namespaces' $@)

if [ -z "$namespaces_input" ]; then
  # namespaces not supplied
  kb_log "--namespaces not supplied. Selecting all namespaces"
  namespaces=($(kubectl get namespaces | awk 'NR>1 {print $1}'))
else
  namespaces=(${(s:,:)namespaces_input})
  kb_log "namespaces = $namespaces"
fi

local resources_input
resources_input=$(utils:get_argument_value '--resources' $@)

if [ -z "$resources_input" ]; then
  kb_log "--resources not supplied. Selecting all resources possible"
  resource_types=($(kubectl "api-resources" | awk 'NR>1 {print $1}'))
else
  resource_types=(${(s:,:)resources_input})
  kb_log "resource_types = $resource_types"
fi

local full_path
local final_command
local resources

kb_log "namespaces: $namespaces"
kb_log "resource_types: $resource_types"

for (( i = 1; i <= ${#namespaces}; i++ )); do
  kb_log "processing for namespace: ${namespaces[$i]}"
  for (( j = 1; j <= ${#resource_types}; j++ )); do
    kb_log "Going to get list of ${resource_types[$j]} in namespace ${namespaces[$i]}"
    resources=($(kubectl get ${resource_types[$j]} -n ${namespaces[$i]} | awk 'NR>1 {print $1}'))
    for (( k = 1; k <= ${#resources}; k++ )); do
      full_path="${base_dir}/${namespaces[$i]}/${resource_types[$j]}"
      mkdir -p $full_path
      full_path+="/${resources[$k]}.yaml"
      if [[ ! -a "$full_path" ]]; then
        final_command="kubectl get ${resource_types[$j]} ${resources[$k]} -n ${namespaces[$i]} -o yaml > ${full_path}"
        kb_log "$final_command"
        eval "$final_command"
      else
        kb_log "File ${full_path} already exists. Skipping"
      fi
    done
  done
done
