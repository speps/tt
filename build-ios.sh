#!/bin/sh

cd `dirname $0`

DIST_DIR=`pwd`/dist

dub build --arch=arm64-apple-ios --config=iOS
libtool -static -o dist/libtt-ios-arm64.a dist/libtt.a ios-libs/*-arm64.a &> /dev/null

dub build --arch=x86_64-apple-ios --config=iOS
libtool -static -o dist/libtt-ios-x86_64.a dist/libtt.a ios-libs/*-x86_64.a &> /dev/null

xcrun -sdk iphoneos lipo -create \
    dist/libtt-ios-arm64.a \
    dist/libtt-ios-x86_64.a \
    -output dist/libtt-ios.a

xcodebuild -project ./ios-project/tt/tt.xcodeproj \
    -scheme tt \
    -sdk iphonesimulator \
    clean build \
    CONFIGURATION_BUILD_DIR=${DIST_DIR} \
    ARCHS=x86_64 \
    ONLY_ACTIVE_ARCH=NO

