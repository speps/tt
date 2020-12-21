#!/bin/sh

cd `dirname $0`

LIBS_DIR=`pwd`
SDL2_VERSION=2.0.12
SDL2_BASE_NAME=SDL2-${SDL2_VERSION}

curl -L -O https://www.libsdl.org/release/${SDL2_BASE_NAME}.tar.gz
tar xvzf ./${SDL2_BASE_NAME}.tar.gz
rm -f ./${SDL2_BASE_NAME}.tar.gz

xcodebuild \
    -project ./${SDL2_BASE_NAME}/Xcode-iOS/SDL/SDL.xcodeproj \
    -scheme libSDL-iOS \
    -sdk iphoneos \
    clean build \
    CONFIGURATION_BUILD_DIR=${LIBS_DIR} \
    ARCHS=arm64 \
    ONLY_ACTIVE_ARCH=NO
mv ${LIBS_DIR}/libSDL2.a ${LIBS_DIR}/libSDL2-arm64.a

xcodebuild \
    -project ./${SDL2_BASE_NAME}/Xcode-iOS/SDL/SDL.xcodeproj \
    -scheme libSDL-iOS \
    -sdk iphonesimulator \
    clean build \
    CONFIGURATION_BUILD_DIR=${LIBS_DIR} \
    ARCHS=x86_64 \
    ONLY_ACTIVE_ARCH=NO
mv ${LIBS_DIR}/libSDL2.a ${LIBS_DIR}/libSDL2-x86_64.a

mkdir -p ./SDL/include
cp -r ./${SDL2_BASE_NAME}/include/* ./SDL/include

