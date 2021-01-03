#!/bin/sh

cd `dirname $0`

LIBS_DIR=`pwd`

git submodule update

cat >> ${LIBS_DIR}/bindbc-sdl/dub.sdl <<EOS
configuration "staticBCwithMixer" {
    dflags "-betterC"
    versions "BindSDL_Static" "SDL_2012" "SDL_Mixer"
    excludedSourceFiles "source/bindbc/sdl/dynload.d"
}
EOS

cd ${LIBS_DIR}/bindbc-sdl
dub build --compiler=ldc2 --arch=arm64-apple-ios --config=staticBCwithMixer
mv lib/libBindBC_SDL.a ${LIBS_DIR}/libBindBC_SDL-arm64.a

dub build --compiler=ldc2 --arch=x86_64-apple-ios --config=staticBCwithMixer
mv lib/libBindBC_SDL.a ${LIBS_DIR}/libBindBC_SDL-x86_64.a

cd ${LIBS_DIR}/bindbc-sdl && git reset --hard

