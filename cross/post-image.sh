#!/bin/sh
# post-image.sh for CircuitCo BeagleBone and TI am335x-evm
# 2014, Marcin Jabrzyk <marcin.jabrzyk@gmail.com>
# 2016, Lothar Felten <lothar.felten@gmail.com>
# 2018, Anton Zhgaylo

BOARD_DIR="$(dirname $0)"

# copy the uEnv.txt to the output/images directory
cp board/beaglebone/uEnv.txt $BINARIES_DIR/uEnv.txt

# copy homebrain files
mkdir -vp $TARGET_DIR/opt/bin
cp $PATH_HB_PRODUCTS/cross/homebrain_core/src/HomeBrain $TARGET_DIR/opt/bin
cp $PATH_HB_PRODUCTS/cross/mqttgateway/src/mqttgtw $TARGET_DIR/opt/bin
mkdir -vp $TARGET_DIR/opt/etc
cp $PATH_HB_PRODUCTS/cross/homebrain_core/HBconfig_target.conf $TARGET_DIR/opt/etc
cp $PATH_HB_PRODUCTS/cross/mqttgateway/gtw_config_target.json $TARGET_DIR/opt/etc

#copy mosquitto files
cp $PATH_HB_CROSS_FILES/mosquitto.conf $TARGET_DIR/etc/mosquitto/

#copy dlt files
mkdir -vp $TARGET_DIR/etc/dlt
cp -r $PATH_HB_INSTALL/cross/dlt-daemon/etc/dlt.conf $TARGET_DIR/etc/dlt
cp -r $PATH_HB_INSTALL/cross/dlt-daemon/etc/dlt_gateway.conf $TARGET_DIR/etc/dlt
cp -r $PATH_HB_INSTALL/cross/dlt-daemon/etc/dlt-kpi.conf $TARGET_DIR/etc/dlt
cp -r $PATH_HB_INSTALL/cross/dlt-daemon/etc/dlt-system.conf $TARGET_DIR/etc/dlt
cp -r $PATH_HB_INSTALL/cross/dlt-daemon/lib/libdlt.so $TARGET_DIR/usr/lib
cp -r $PATH_HB_INSTALL/cross/dlt-daemon/lib/libdlt.so.2 $TARGET_DIR/usr/lib
cp -r $PATH_HB_INSTALL/cross/dlt-daemon/lib/libdlt.so.2.17.0 $TARGET_DIR/usr/lib
cp $PATH_HB_INSTALL/cross/dlt-daemon/bin/dlt-daemon $TARGET_DIR/usr/sbin

#copy systemd files
cp $PATH_HB_CROSS_FILES/hb.target $TARGET_DIR/etc/systemd/system
cp $PATH_HB_CROSS_FILES/homebrain.service $TARGET_DIR/etc/systemd/system
cp $PATH_HB_CROSS_FILES/mqttgtw.service $TARGET_DIR/etc/systemd/system
cp $PATH_HB_CROSS_FILES/mnt-data.mount $TARGET_DIR/etc/systemd/system
cp $PATH_HB_CROSS_FILES/mosquitto.service $TARGET_DIR/usr/lib/systemd/system
cp $PATH_HB_CROSS_FILES/dhcp.network $TARGET_DIR/etc/systemd/network

cd $TARGET_DIR/etc/systemd/system
sudo ln -sf ../../../../etc/systemd/system/hb.target multi-user.target.wants/hb.target
cd -

# HOST_DIR = /home/azhigaylo/project/homebrain_third_party/host/buildroot/output/host
# STAGING_DIR = /home/azhigaylo/project/homebrain_third_party/host/buildroot/output/host/arm-buildroot-linux-gnueabihf/sysroot
# TARGET_DIR = /home/azhigaylo/project/homebrain_third_party/host/buildroot/output/target
# BUILD_DIR = /home/azhigaylo/project/homebrain_third_party/host/buildroot/output/build
# BINARIES_DIR = /home/azhigaylo/project/homebrain_third_party/host/buildroot/output/images
# BASE_DIR = /home/azhigaylo/project/homebrain_third_party/host/buildroot/output

rm -rf "${GENIMAGE_TMP}"

