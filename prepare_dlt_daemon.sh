#!/bin/bash

#according to instructions of https://github.com/GENIVI/dlt-daemon

source $( dirname $( realpath -s $0 ) )/utils/utils.lib

trap 'on_abort DLT-DAEMON' ERR SIGQUIT SIGTERM SIGINT
trap 'on_success DLT-DAEMON' EXIT
on_startup "DLT-DAEMON"

set -e

# parse cmd options.
source $( dirname $( realpath -s $0 ))/utils/prepare_option_parser.lib

readonly target_name=dlt-daemon
readonly required_version="2.17.0"
readonly repolink="https://github.com/GENIVI/dlt-daemon.git"

# check if exists
if `pkg-config --exists automotive-dlt`
then
    readonly package_version=`pkg-config --modversion automotive-dlt`

    echo " ---> $target_name found(installed package version $package_version, minimum required $required_version)."
    readonly version_compare_result=$(version_compare $required_version $package_version)
    if [ "$force_mode" = true ]
    then
        echo " ---> Force preparation reuested. Preparation for $target_name REQUIRED."
    else
        case $version_compare_result in
            "="|"<") echo " ---> Preparation for $target_name will be SKIPPED."; exit 0; ;;
            ">")   echo " ---> Preparation for $target_name REQUIRED."; ;;
        esac
    fi
else
    echo " ---> $target_name have NOT been found."
    echo " ---> Preparation for $target_name REQUIRED."
fi

libs_to_install=" zlib1g-dev libdbus-glib-1-dev "
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

readonly module_products_root_path="$products_root_path/$target_name"
echo " ---> Products path for '$target_name' = $module_products_root_path"

if ! [ -d $module_products_root_path ]
then
    mkdir -vp $module_products_root_path
    echo " ---> Create $module_products_root_path"
fi

readonly module_install_prefix_path="$install_prefix_path/$target_name"
echo " ---> Products path for '$target_name' = $module_install_prefix_path"

if ! [ -d $module_install_prefix_path ]
then
    mkdir -vp $module_install_prefix_path
    echo " ---> Create $module_install_prefix_path"
fi

# do NOT use dlt-dbus
cmake_arg_list=" -DWITH_DLT_DBUS=OFF "

cmake_arg_list+=" -DWITH_DLT_EXAMPLES=OFF "
cmake_arg_list+=" -DWITH_DLT_TESTS=OFF "
cmake_arg_list+=" -DWITH_DLT_UNIT_TESTS=OFF "
cmake_arg_list+=" -DBUILD_SHARED_LIBS=ON "
cmake_arg_list+=" -DWITH_SYSTEMD_WATCHDOG=OFF "
cmake_arg_list+=" -DWITH_SYSTEMD_JOURNAL=OFF "
cmake_arg_list+=" -DWITH_DOC=OFF "
cmake_arg_list+=" -DWITH_MAN=OFF "
cmake_arg_list+=" -DDLT_USER=root "
cmake_arg_list+=" -DWITH_SYSTEMD=OFF "

if [ "$cross_mode" = true ]
then
    cmake_arg_list=" -DCMAKE_TOOLCHAIN_FILE=/home/azhigaylo//project/homebrain/build/cross/hb_toolchain_def.cmake"
fi

# build project based on CMake build system
# install if requested
build_cmake_project $module_source_root_path $module_products_root_path $module_install_prefix_path

