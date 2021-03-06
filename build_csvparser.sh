#!/bin/bash

source $( dirname $( realpath -s $0 ) )/utils/utils.lib

trap 'on_abort csvparser' ERR SIGQUIT SIGTERM SIGINT
trap 'on_success csvparser' EXIT
on_startup "csvparser"

set -e

# parse cmd options.
source $( dirname $( realpath -s $0 ))/utils/build_option_parser.lib

readonly target_name=csvparser

if [ "$cross_mode" = true ]
then
    echo " --->'$target_name' will be skipped, needed only for target"
    exit 0;
fi

readonly module_source_root_path="$source_root_path/$target_name"
echo " ---> Source path for '$target_name' = $module_source_root_path"

readonly module_products_root_path="$products_root_path/$target_name"
echo " ---> products path for '$target_name' = $module_install_root_path"

if [ "$with_clean" = true ]
then
    remove_directory $module_products_root_path
fi

if ! [ -d $module_products_root_path ]
then
    mkdir -vp $module_products_root_path
    echo " ---> Create $module_products_root_path"
fi

# build project based on CMake build system
build_cmake_project $module_source_root_path $module_products_root_path



