#!/bin/sh

cd `dirname $0`

LIBS_DIR=`pwd`

LDC2_HOME=`which ldc2`
LDC2_HOME=`dirname $LDC2_HOME`
LDC2_HOME=`dirname $LDC2_HOME`

cp ${LDC2_HOME}/lib-ios-arm64/libdruntime-ldc.a ${LIBS_DIR}/libdruntime-ldc-arm64.a
cp ${LDC2_HOME}/lib-ios-x86_64/libdruntime-ldc.a ${LIBS_DIR}/libdruntime-ldc-x86_64.a

cp ${LDC2_HOME}/lib-ios-arm64/libphobos2-ldc.a ${LIBS_DIR}/libphobos2-ldc-arm64.a
cp ${LDC2_HOME}/lib-ios-x86_64/libphobos2-ldc.a ${LIBS_DIR}/libphobos2-ldc-x86_64.a

