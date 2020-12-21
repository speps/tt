#!/bin/sh

cd `dirname $0`

LIBS_DIR=`pwd`
SDL2_VERSION=2.0.12
SDL2_BASE_NAME=SDL2-${SDL2_VERSION}

SDL2_MIXER_VERSION=2.0.4
SDL2_MIXER_BASE_NAME=SDL2_mixer-${SDL2_MIXER_VERSION}

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

xcrun -sdk iphoneos lipo -create \
        ${LIBS_DIR}/libSDL2-arm64.a \
        ${LIBS_DIR}/libSDL2-x86_64.a \
	-output ${LIBS_DIR}/libSDL2-ios.a

mkdir -p ./SDL/include
cp -r ./${SDL2_BASE_NAME}/include/* ./SDL/include

curl -L -O https://www.libsdl.org/projects/SDL_mixer/release/${SDL2_MIXER_BASE_NAME}.tar.gz
tar xvzf ./${SDL2_MIXER_BASE_NAME}.tar.gz
rm -f ./${SDL2_MIXER_BASE_NAME}.tar.gz

xcodebuild \
    -project ./${SDL2_MIXER_BASE_NAME}/Xcode-iOS/SDL_mixer.xcodeproj \
    -scheme libSDL_mixer-iOS \
    -sdk iphoneos \
    clean build \
    CONFIGURATION_BUILD_DIR=${LIBS_DIR} \
    ARCHS=arm64 \
    ONLY_ACTIVE_ARCH=NO
mv ${LIBS_DIR}/libSDL2_mixer.a ${LIBS_DIR}/libSDL2_mixer-arm64.a

xcodebuild \
    -project ./${SDL2_MIXER_BASE_NAME}/Xcode-iOS/SDL_mixer.xcodeproj \
    -scheme libSDL_mixer-iOS \
    -sdk iphonesimulator \
    clean build \
    CONFIGURATION_BUILD_DIR=${LIBS_DIR} \
    ARCHS=x86_64 \
    ONLY_ACTIVE_ARCH=NO
mv ${LIBS_DIR}/libSDL2_mixer.a ${LIBS_DIR}/libSDL2_mixer-x86_64.a

xcrun -sdk iphoneos lipo -create \
        ${LIBS_DIR}/libSDL2_mixer-arm64.a \
        ${LIBS_DIR}/libSDL2_mixer-x86_64.a \
	-output ${LIBS_DIR}/libSDL2_mixer-ios.a

