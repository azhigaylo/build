#!/bin/bash

#according to instructions of https://github.com/Kitware/CMake

source $( dirname $( realpath -s $0 ))/utils/utils.lib

trap 'on_abort CMAKE' ERR SIGQUIT SIGTERM SIGINT
trap 'on_success CMAKE' EXIT
on_startup "CMAKE"

set -e

# parse cmd options.
source $( dirname $( realpath -s $0 ))/utils/prepare_option_parser.lib

readonly target_name="CMake"
readonly required_version="3.16.5"
readonly repolink="https://github.com/Kitware/CMake.git"

if [ "$cross_mode" = true ]
then
    echo " --->'$target_name' will be skipped, needed only for host"
    exit 0;
fi

# check if exists
target_found=true
cmake --version >/dev/null 2>&1 || { target_found=false; echo " ---	> $target_name have NOT been installed."; }

set_system_cmake="true"

if [ $target_found == "true" ]
then
    readonly target_version=`cmake --version`
    readonly package_version=`echo $target_version | sed "s/^.*cmake version \([0-9.]*\).*/\1/"`

    echo " ---> $target_name found(installed package version $package_version, minimum required $required_version)."
    version_compare_result=$(version_compare $required_version $package_version)
    if [ "$force_mode" = true ]
    then
        echo " ---> Force preparation requested. Preparation for $target_name REQUIRED."
    else
        case $version_compare_result in
            "="|"<") echo " ---> Preparation for system $target_name will be SKIPPED."; set_system_cmake="false"; ;;
            ">")   echo " ---> Preparation for $target_name REQUIRED."; ;;
        esac
    fi
else
    echo " ---> $target_name have NOT been found."
    echo " ---> Preparation for $target_name REQUIRED."
fi

libs_to_install=" openssl libssl-dev "
echo " ---> Installing required libraries: $libs_to_install"
install_package $libs_to_install

echo " ---> Required libraries have been successfully installed."

if [ $target_found == "true" ]
then
    # check for available binaries from standard repositories
    readonly apt_package_version=`apt-cache show cmake | grep Version | head -1 | sed "s/^.*Version: \([0-9.]*\).*/\1/"`

    version_compare_result=$(version_compare $apt_package_version $required_version)
    case $version_compare_result in
        "<")
            echo " ---> Available $target_name version from standard repositories: '$apt_package_version' but required: '$required_version'";;
        "="|">")
            echo " ---> !!!Trying to install $target_name using apt-get.."
            if [ "$force_mode" = true ]
            then
                install_package --reinstall cmake
            else
                install_package cmake
            fi
            echo "$target_name have been successfully installed!";
    esac
fi

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
    #echo " ---> Checkout to version v$required_version"
    #git -C $module_source_root_path reset --hard "v$required_version"
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

bootstrap_options+=" --prefix=$module_install_prefix_path"

# option --system-curl needed for ExternalProject_Add to work with 'https' protocol
bootstrap_options+=" --system-curl --parallel=-j`nproc` "

cd $module_products_root_path
echo " ---> Running $module_source_root_path/bootstrap $bootstrap_options"
eval $module_source_root_path/bootstrap $bootstrap_options
cd -

build_make_project $module_products_root_path
