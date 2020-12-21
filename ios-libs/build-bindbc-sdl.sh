#!/bin/sh

cd `dirname $0`

LIBS_DIR=`pwd`

cd ${LIBS_DIR}/bindbc-sdl
dub build --arch=arm64-apple-ios --config=staticBC
mv lib/libBindBC_SDL.a ${LIBS_DIR}/libBindBC_SDL-arm64.a

dub build --arch=x86_64-apple-ios --config=staticBC
mv lib/libBindBC_SDL.a ${LIBS_DIR}/libBindBC_SDL-x86_64.a

xcrun -sdk iphoneos lipo -create \
        ${LIBS_DIR}/libBindBC_SDL-arm64.a \
        ${LIBS_DIR}/libBindBC_SDL-x86_64.a \
	-output ${LIBS_DIR}/libBindBC_SDL-ios.a

