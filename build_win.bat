@echo off
setlocal EnableDelayedExpansion

mkdir upload
mkdir upload\include\curl
mkdir upload\Debug
mkdir upload\Release

REM Download latest libcurl
git clone --branch curl-8_12_1 --single-branch https://github.com/curl/curl

REM Install dependencies
vcpkg install zlib
vcpkg install brotli

REM Build Debug configuration
cmake -S curl -B build -D CMAKE_BUILD_TYPE=Debug -D CURL_ZLIB=OFF -D CURL_ZSTD=OFF -D CURL_BROTLI=OFF -D USE_NGHTTP2=OFF -D USE_LIBIDN2=OFF -D BUILD_CURL_EXE=OFF -D BUILD_EXAMPLES=OFF -D BUILD_LIBCURL_DOCS=OFF -D BUILD_MISC_DOCS=OFF -D BUILD_TESTING=OFF -D CURL_ENABLE_SSL=ON -D ENABLE_CURL_MANUAL=OFF -D PICKY_COMPILER=OFF
cmake --build build --config Debug
cmake --install build

REM Copy over the built files
copy /y /v build\Debug\*.dll upload\Debug
copy /y /v build\Debug\*.lib upload\Debug
copy /y /v build\Debug\*.pdb upload\Debug

REM Clean up before we run CMake again
rmdir /s /q build

REM Build Release configuration
cmake -S curl -B build -D CMAKE_BUILD_TYPE=Release -D CURL_ZLIB=OFF -D CURL_ZSTD=OFF -D CURL_BROTLI=OFF -D USE_NGHTTP2=OFF -D USE_LIBIDN2=OFF -D BUILD_CURL_EXE=OFF -D BUILD_EXAMPLES=OFF -D BUILD_LIBCURL_DOCS=OFF -D BUILD_MISC_DOCS=OFF -D BUILD_TESTING=OFF -D CURL_ENABLE_SSL=ON -D ENABLE_CURL_MANUAL=OFF -D PICKY_COMPILER=OFF
cmake --build build --config Release
cmake --install build

REM Copy over the built files
copy /y /v build\Release\*.dll upload\Release
copy /y /v build\Release\*.lib upload\Release

REM Copy over the headers
copy /y /v curl\include\curl upload\include\curl

exit /b
