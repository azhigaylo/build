#!/bin/bash

#according to instructions of https://github.com/GENIVI/dlt-daemon

source $( dirname $( realpath -s $0 ) )/utils/utils.lib

trap 'on_abort mosquitto' ERR SIGQUIT SIGTERM SIGINT
trap 'on_success mosquitto' EXIT
on_startup "mosquitto"

set -e

# parse cmd options.
source $( dirname $( realpath -s $0 ))/utils/prepare_option_parser.lib

# mosquito do not have installation procedure
need_install=false

readonly target_name=mosquitto
readonly required_version="1.5.1"
readonly repolink="https://github.com/eclipse/mosquitto.git"

libs_to_install=" libc-ares-dev uuid-dev libwebsockets-dev libssl-dev xsltproc docbook-xsl "
echo " ---> Installing required libraries: $libs_to_install"
install_package $libs_to_install

echo " ---> Required packages have been successfully installed."

readonly module_source_root_path="$third_party_source_root_path/$target_name"
echo " ---> Source path for '$target_name' = $module_source_root_path"

if [ "$with_clean" = true ]
then
    remove_directory $module_source_root_path
fi

if ! [ -d $module_source_root_path ]
then
    mkdir -vp $module_source_root_path
    echo " ---> Cloning $repolink to $module_source_root_path"
    git -C $module_source_root_path clone $repolink $module_source_root_path
    echo " ---> Checkout to version v$required_version"
    git -C $module_source_root_path reset --hard "v$required_version"
fi

readonly module_install_root_path="$products_root_path/$target_name"
echo " ---> Install path for '$target_name' = $module_install_root_path"

if ! [ -d $module_install_root_path ]
then
    mkdir -vp $module_install_root_path
    echo " ---> Create $module_install_root_path"
fi

# do NOT use dlt-dbus
cmake_arg_list=" "

# build project based on CMake build system
# install if requested
build_cmake_project $module_source_root_path $module_install_root_path


