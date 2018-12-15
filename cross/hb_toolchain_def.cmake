set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(tools /home/azhigaylo/project/homebrain_third_party/host/buildroot/output/host/)
set(target /home/azhigaylo/project/homebrain_third_party/host/buildroot/output/target/)

set(CMAKE_SYSROOT ${tools}/arm-buildroot-linux-gnueabihf/sysroot)
set(CMAKE_C_COMPILER ${tools}/bin/arm-buildroot-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER ${tools}/bin/arm-buildroot-linux-gnueabihf-g++)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(
  CMAKE_FIND_ROOT_PATH 
  ${target}
  ${target}/usr/lib
)

include_directories(
  ${tools}/usr/include
  ${target}/usr/include
  ${tools}/usr/arm-buildroot-linux-gnueabihf/sysroot/usr/include
)
