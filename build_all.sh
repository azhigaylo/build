#!/bin/bash

source $( dirname $( realpath -s $0 ))/utils/utils.lib

trap 'on_abort "BUILD HOST"' ERR SIGQUIT SIGTERM SIGINT
trap 'on_success "BUILD HOST"' EXIT
on_startup "BUILD HOST"

# exit by any error
set -e

# if --install option is NOT specified
readonly arglist="$@"

# parse cmd options.
source $( dirname $( realpath -s $0 ))/utils/build_option_parser.lib

# source all environment variable
if [ "$cross_mode" = false ]
then
    source env_host.sh
else
    source env_cross.sh
fi

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
  mkdir -p $products_root_path
fi

echo " ---> Create projects dir if it's need.."
if [ -d $projects_root_path ]
then
  echo "$projects_root_path exists"
else
  echo "$projects_root_path NOT exists, create it"
  mkdir -p $projects_root_path
fi

$script_root_path/build_homebrain.sh $arglist
$script_root_path/build_pointmonitor.sh $arglist
$script_root_path/build_mqttgtw.sh $arglist
$script_root_path/build_csvparser.sh $arglist
$script_root_path/build_wirelessbridge.sh $arglist

if [ "$cross_mode" = true ]
then
    # clear LD_LIBRARY_PATH(buildroot requirement)
    export LD_LIBRARY_PATH=""

    echo " ---> copy beaglebone_homebrain_defconfig to $PATH_HB_INSTALL/host/buildroot/configs"
    cp "$script_root_path"/cross/beaglebone_homebrain_defconfig $PATH_HB_INSTALL/host/buildroot/configs
    echo " ---> copy post-build.sh to $PATH_HB_INSTALL/host/buildroot/board/beaglebone"
    cp "$script_root_path"/cross/post-build.sh $PATH_HB_INSTALL/host/buildroot/board/beaglebone

    echo " ---> Make default configuration for buildroot"
    cd $PATH_HB_INSTALL/host/buildroot
    make beaglebone_homebrain_defconfig

    echo " ---> Make buildroot"
    make 2>&1 | tee buildroot.log
fi
