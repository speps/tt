#!/bin/sh

cd `dirname $0`

LIBS_DIR=`pwd`

git submodule update

cd ${LIBS_DIR}/bindbc-sdl
dub build --arch=arm64-apple-ios --config=staticBC
mv lib/libBindBC_SDL.a ${LIBS_DIR}/libBindBC_SDL-arm64.a

dub build --arch=x86_64-apple-ios --config=staticBC
mv lib/libBindBC_SDL.a ${LIBS_DIR}/libBindBC_SDL-x86_64.a

