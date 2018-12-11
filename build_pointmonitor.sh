#!/bin/bash

source $( dirname $( realpath -s $0 ) )/utils/utils.lib

trap 'on_abort pointmonitor' ERR SIGQUIT SIGTERM SIGINT
trap 'on_success pointmonitor' EXIT
on_startup "pointmonitor"

set -e

# parse cmd options.
source $( dirname $( realpath -s $0 ))/utils/build_option_parser.lib

readonly target_name=pointmonitor

readonly module_source_root_path="$source_root_path/$target_name"
echo " ---> Source path for '$target_name' = $module_source_root_path"

readonly module_products_root_path="$products_root_path/$target_name"
echo " ---> Install path for '$target_name' = $module_install_root_path"

if [ "$with_clean" = true ]
then
    remove_directory $module_products_root_path
fi

if ! [ -d $module_products_root_path ]
then
    mkdir -vp $module_products_root_path
    echo " ---> Create $module_products_root_path"
fi

# find QT locaton
readonly qt5_required_version="5.11.0"

# check if exists
if `pkg-config --exists Qt5Core`
then
    readonly qt5_version=`pkg-config --modversion Qt5Core`

    echo " ---> qt5 found, version $qt5_version, minimum required $qt5_required_version)."
    readonly version_compare_result=$(version_compare $qt5_version $qt5_required_version)

    case $version_compare_result in
        "="|"<") echo -e " ---> \033[0;41m!!!CAUTION: QT5 version required $qt5_required_version.\033[0m"; exit 0; ;;
        ">")   echo " ---> QT5 version OK"; ;;
    esac
else
    echo -e " ---> \033[0;41m!!!CAUTION: Qt5 have NOT been found, try to set PKG_CONFIG_PATH for QT5 in env.sh \033[0m"
    exit 0
fi

readonly qt5_lib_dir=`pkg-config --variable=libdir Qt5Core`
readonly qt5_lib_cmake_dir="$qt5_lib_dir"/cmake/Qt5

cmake_arg_list=" -DCMAKE_PREFIX_PATH=$qt5_lib_cmake_dir "

# build project based on CMake build system
build_cmake_project $module_source_root_path $module_products_root_path


