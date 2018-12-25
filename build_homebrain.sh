#!/bin/bash

source $( dirname $( realpath -s $0 ) )/utils/utils.lib

trap 'on_abort homebrain' ERR SIGQUIT SIGTERM SIGINT
trap 'on_success homebrain' EXIT
on_startup "homebrain"

set -e

# parse cmd options.
source $( dirname $( realpath -s $0 ))/utils/build_option_parser.lib

readonly target_name=homebrain

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

if [ "$cross_mode" = true ]
then
    cmake_arg_list=" -DCMAKE_TOOLCHAIN_FILE=/home/azhigaylo/project/homebrain/build/cross/hb_toolchain_def.cmake"
fi

# build project based on CMake build system
build_cmake_project $module_source_root_path $module_products_root_path

cp $module_source_root_path/config/HBconfig.conf $module_products_root_path
