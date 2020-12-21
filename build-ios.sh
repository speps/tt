#!/bin/sh

dub build --arch=arm64-apple-ios --config=iOS
mv dist/libtt.a dist/libtt-ios-arm64.a

dub build --arch=x86_64-apple-ios --config=iOS
mv dist/libtt.a dist/libtt-ios-x86_64.a

xcrun -sdk iphoneos lipo -create \
    dist/libtt-ios-arm64.a \
    dist/libtt-ios-x86_64.a \
    -output dist/libtt-ios.a

