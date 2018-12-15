#!/bin/bash

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/azhigaylo/project/homebrain_third_party/cross/mosquitto/lib
export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:/home/azhigaylo/project/homebrain_third_party/cross/mosquitto/
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/home/azhigaylo/project/homebrain_third_party/cross/mosquitto/lib/pkgconfig/

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/azhigaylo/project/homebrain_third_party/cross/dlt-daemon/lib/
export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:/home/azhigaylo/project/homebrain_third_party/cross/dlt-daemon/
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/home/azhigaylo/project/homebrain_third_party/cross/dlt-daemon/lib/pkgconfig/

echo " ---> PKG_CONFIG_PATH = $PKG_CONFIG_PATH "
echo " ---> CMAKE_PREFIX_PATH = $CMAKE_PREFIX_PATH "
