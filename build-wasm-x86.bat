@echo off
set cmd=%1
if "%cmd%"=="" (
  set cmd=build
)
dub %cmd% --compiler=ldc2 --arch=x86 --verbose --force --config=wasm_debug