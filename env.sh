#!/bin/bash

# set Qt5 *.pc files 
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/home/azhigaylo/Qt/5.11.1/gcc_64/lib/pkgconfig/


export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/azhigaylo/project/homebrain_third_party/mosquitto/lib
export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:/home/azhigaylo/project/homebrain_third_party/mosquitto/
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/home/azhigaylo/project/homebrain_third_party/mosquitto/lib/pkgconfig/

echo " ---> PKG_CONFIG_PATH = $PKG_CONFIG_PATH "
echo " ---> CMAKE_PREFIX_PATH = $CMAKE_PREFIX_PATH "
