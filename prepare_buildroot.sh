#!/bin/bash

#according to instructions of https://bootlin.com/doc/training/buildroot/buildroot-labs.pdf
# buildroot do not have installation procedure

source $( dirname $( realpath -s $0 ) )/utils/utils.lib

trap 'on_abort buildroot' ERR SIGQUIT SIGTERM SIGINT
trap 'on_success buildroot' EXIT
on_startup "buildroot"

set -e

# parse cmd options.
source $( dirname $( realpath -s $0 ))/utils/prepare_option_parser.lib

readonly target_name=buildroot
readonly repolink="https://git.buildroot.net/git/buildroot.git"
readonly build_root_tag="2018.11.4"

if [ "$cross_mode" = true ]
then
    echo " --->'$target_name' will be skipped, needed only for target"
    exit 0;
fi

libs_to_install=" binutils patch gzip bzip2 perl tar cpio python unzip rsync wget libncurses-dev "

echo " ---> Installing required libraries: $libs_to_install"
install_package $libs_to_install

echo " ---> Required packages have been successfully installed."

readonly module_install_path="$install_prefix_path/$target_name"
echo " ---> Products path for '$target_name' = $module_install_path"

if [ "$with_clean" = true ]
then
    remove_directory $module_install_path
fi

if ! [ -d $module_install_path ]
then
    mkdir -vp $module_install_path
    echo " ---> Cloning $repolink to $module_install_path"
    git -C $module_install_path clone --branch $build_root_tag $repolink $module_install_path
fi

if [ -d $module_install_path ]
then

    export LD_LIBRARY_PATH=""

    echo " ---> copy beaglebone_homebrain_defconfig to $PATH_HB_INSTALL/host/buildroot/configs"
    cp "$script_root_path"/cross/beaglebone_homebrain_defconfig $module_install_path/configs

    echo " ---> Make default configuration for $target_name"
    cd $module_install_path
    make beaglebone_homebrain_defconfig

    echo " ---> Make $target_name"
    make 2>&1 | tee buildroot.log
fi
