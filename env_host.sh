#!/bin/bash

readonly local _project_root_path=$( dirname $( dirname $( dirname $( realpath -s $0))))
readonly local _project_name=$( basename $( dirname $( dirname $( realpath -s $0} ) ) ))
readonly local _install_path="$_project_root_path"/"$_project_name"_third_party
readonly local _products_path="$_project_root_path"/"$_project_name"_products
readonly local _source_files_path="$_install_path"/host

# set Qt5 *.pc files 
export PKG_CONFIG_PATH=/home/azhigaylo/Qt/5.11.1/gcc_64/lib/pkgconfig/

export PATH_HB_PRODUCTS="$_products_path"
export PATH_HB_INSTALL="$_install_path"
export LD_LIBRARY_PATH=""
export CMAKE_PREFIX_PATH=""

if [ -d $_source_files_path ]
then
   cd "$_source_files_path"
       for _env_file in **/set_*_env.sh; do
          if [ $_env_file != "**/set_*_env.sh" ]
           then
               echo " ---> source $_env_file"
               source $_env_file > /dev/null;
           fi
       done
       echo " ---> source result:"
       echo " ---> PATH_HB_INSTALL='$PATH_HB_INSTALL'"
       echo " ---> LD_LIBRARY_PATH='$LD_LIBRARY_PATH'"
       echo " ---> CMAKE_PREFIX_PATH='$CMAKE_PREFIX_PATH'"
       echo " ---> PKG_CONFIG_PATH='$PKG_CONFIG_PATH'"
   cd -
fi
