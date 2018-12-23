#!/bin/bash

export PATH_HB=/home/azhigaylo/project/homebrain_third_party/
export PKG_CONFIG_PATH=""
export LD_LIBRARY_PATH=""
export CMAKE_PREFIX_PATH=""

readonly local _project_root_path=$( dirname $( dirname $( dirname $( realpath -s $0))))
readonly local _project_name=$( basename $( dirname $( dirname $( realpath -s $0} ) ) ))
readonly local _source_files_path="$_project_root_path"/"$_project_name"_third_party/cross

cd "$_source_files_path"
    for _env_file in **/set_*_env.sh; do
        echo " ---> source $_env_file"
        source $_env_file > /dev/null;
    done
    echo " ---> source result:"
    echo " ---> LD_LIBRARY_PATH='$LD_LIBRARY_PATH'"
    echo " ---> CMAKE_PREFIX_PATH='$CMAKE_PREFIX_PATH'"
    echo " ---> PKG_CONFIG_PATH='$PKG_CONFIG_PATH'"
cd -
