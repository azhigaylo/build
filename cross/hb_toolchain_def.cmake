set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(tools $ENV{PATH_HB}/host/buildroot/output/host/)
set(target $ENV{PATH_HB}/host/buildroot/output/target/)

set(CMAKE_SYSROOT ${tools}/arm-buildroot-linux-gnueabihf/sysroot)
set(CMAKE_C_COMPILER ${tools}/bin/arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER ${tools}/bin/arm-linux-gnueabihf-g++)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE BOTH)
set(THREADS_PTHREAD_ARG 0)

set(
  CMAKE_FIND_ROOT_PATH 
  ${target}
  ${target}/usr/lib
  ${tools}/usr/arm-buildroot-linux-gnueabihf/sysroot/usr/lib
)

include_directories(
  ${target}/usr/include
  ${tools}/usr/include
  ${tools}/usr/arm-buildroot-linux-gnueabihf/sysroot/usr/include
)
