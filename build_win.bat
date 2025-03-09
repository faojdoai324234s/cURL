@echo off
setlocal EnableDelayedExpansion

mkdir upload
mkdir upload\include\curl
mkdir upload\Debug
mkdir upload\Release

REM Download latest libcurl
git clone https://github.com/curl/curl

REM Build Debug configuration
cmake -S curl -B build -D WITH_SSL=dll -D ENABLE_SSPI=no -D ENABLE_IDN=no -D ENABLE_SCHANNEL=no -D SSL_PATH="C:\Program Files\OpenSSL" -D CMAKE_BUILD_TYPE=Debug
cmake --build build --config Debug
cmake --install build

REM Copy over the built files
copy /y /v build\Debug\*.dll upload\Debug
copy /y /v build\Debug\*.lib upload\Debug
copy /y /v build\Debug\*.pdb upload\Debug

REM Clean up before we run CMake again
rmdir /s /q build

REM Build Release configuration
cmake -S curl -B build -D WITH_SSL=dll -D ENABLE_SSPI=no -D ENABLE_IDN=no -D ENABLE_SCHANNEL=no -D SSL_PATH="C:\Program Files\OpenSSL" -D CMAKE_BUILD_TYPE=Release
cmake --build build --config Release
cmake --install build

REM Copy over the built files
copy /y /v build\Release\*.dll upload\Release
copy /y /v build\Release\*.lib upload\Release

REM Copy over the headers
xcopy /y /v /s /e curl\include\curl upload\include\curl

exit /b
