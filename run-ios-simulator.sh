#!/bin/sh

cd `dirname $0`

APP_ID=com.example.tt
APP_BUNDLE_PATH=`pwd`/dist/tt.app
DEVICE_ID="547B7D16-D2AA-40D1-A807-61D083A71CA8"

xcrun simctl boot ${DEVICE_ID}
xcrun simctl install ${DEVICE_ID} ${APP_BUNDLE_PATH}
xcrun simctl launch ${DEVICE_ID}  ${APP_ID}

