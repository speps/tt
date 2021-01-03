#!/bin/sh

cd `dirname $0`

IOS_DIR=`pwd`
LIBS_DIR=${IOS_DIR}/libs
BUILD_DIR=${IOS_DIR}/project/build

cd ../

DIST_DIR=`pwd`/dist

dub build --arch=arm64-apple-ios --config=iOS || exit $?
libtool -static -o ${LIBS_DIR}/libtt-ios-arm64.a ${DIST_DIR}/libtt.a ${LIBS_DIR}/*-arm64.a &> /dev/null || exit $?

dub build --arch=x86_64-apple-ios --config=iOS || exit $?
libtool -static -o ${LIBS_DIR}/libtt-ios-x86_64.a ${DIST_DIR}/libtt.a ${LIBS_DIR}/*-x86_64.a &> /dev/null || exit $?

xcrun -sdk iphoneos lipo -create \
    ${LIBS_DIR}/libtt-ios-arm64.a \
    ${LIBS_DIR}/libtt-ios-x86_64.a \
    -output ${LIBS_DIR}/libtt-ios.a \
    &> /dev/null

xcodebuild -project ${IOS_DIR}/project/tt.xcodeproj \
    -scheme tt \
    -sdk iphonesimulator \
    clean build \
    CONFIGURATION_BUILD_DIR=${BUILD_DIR} \
    ARCHS=x86_64 \
    ONLY_ACTIVE_ARCH=NO 

