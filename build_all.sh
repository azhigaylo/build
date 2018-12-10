#!/bin/bash

source $( dirname $( realpath -s $0 ))/utils/utils.lib

trap 'on_abort "BUILD HOST"' ERR SIGQUIT SIGTERM SIGINT
trap 'on_success "BUILD HOST"' EXIT
on_startup "BUILD HOST"

# exit by any error
set -e


# source all environment variable
source env.sh

# if --install option is NOT specified
readonly arglist="$@"

# parse cmd options.
source $( dirname $( realpath -s $0 ))/utils/build_option_parser.lib

echo "
***********************************************
used path:
   products path  = $products_root_path
   source path    = $source_root_path
   project path   = $projects_root_path
***********************************************"

echo " ---> Create poducts dir if it's need.."
if [ -d $products_root_path ]
then
  echo "$products_root_path exists"
else
  echo "$products_root_path NOT exists, create it"
  mkdir $products_root_path
fi

echo " ---> Create projects dir if it's need.."
if [ -d $projects_root_path ]
then
  echo "$projects_root_path exists"
else
  echo "$projects_root_path NOT exists, create it"
  mkdir $projects_root_path
fi

$script_root_path/build_homebrain.sh $arglist
$script_root_path/build_pointmonitor.sh $arglist
$script_root_path/build_mqttgtw.sh $arglist
$script_root_path/build_csvparser.sh $arglist
