#!/bin/bash

source $( dirname $( realpath -s $0 ))/utils/utils.lib

trap 'on_abort HOST WORKSPACE PREPARATION' ERR SIGQUIT SIGTERM SIGINT
trap 'on_success HOST WORKSPACE PREPARATION' EXIT
on_startup "HOST WORKSPACE PREPARATION"

# exit by any error
set -e

# if --install option is NOT specified
readonly arglist="$@"

# parse cmd options.
source $( dirname $( realpath -s $0 ))/utils/prepare_option_parser.lib

echo "
***********************************************
used path:
   products path            = $products_root_path
   third party install path = $install_prefix_path
   third party source path  = $third_party_source_root_path
***********************************************"

echo " ---> Prepare tools and libraries..."
echo " ---> !!!(ROOT PERMISSIONS REQUIRED) Running sudo apt-get update.."
sudo apt-get update

# needed for boost setup
tools_to_install+=" build-essential python-dev autotools-dev libicu-dev libbz2-dev g++ "
# another tools
tools_to_install+=" curl make gcc unzip git "
echo -e " ---> \033[0;7m Installing required tools: \033[0m $tools_to_install "
sudo apt-get install -y $tools_to_install

libs_to_install+=" libtar-dev libboost-dev libcurl4-openssl-dev libncurses5-dev "
echo -e " ---> \033[0;7m Installing required libraries: \033[0m $libs_to_install"
sudo apt-get install -y $libs_to_install

echo " ---> Create poducts dir if it's need.."
if [ -d $products_root_path ]
then
  echo "$products_root_path exists"
else
  echo "$products_root_path NOT exists, create it"
  mkdir $products_root_path
fi

echo " ---> Create third party dir if it's need.."
if [ -d $third_party_source_root_path ]
then
  echo "$third_party_source_root_path exists"
else
  echo "$third_party_source_root_path NOT exists, create it"
  mkdir $third_party_source_root_path
fi

$script_root_path/prepare_cmake.sh $arglist
$script_root_path/prepare_dlt_daemon.sh $arglist
$script_root_path/prepare_mosquitto.sh $arglist


