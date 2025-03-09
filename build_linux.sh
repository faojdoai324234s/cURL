#!/bin/bash

# Prepare the build with creating the file structure
mkdir upload
mkdir upload/include
mkdir upload/include/curl
mkdir upload/Debug
mkdir upload/Release

git clone --branch curl-8_12_1 --single-branch https://github.com/curl/curl

# Build Debug configuration
cmake -S curl -B build -D CMAKE_BUILD_TYPE=Debug -D CURL_ZLIB=OFF -D CURL_ZSTD=OFF -D CURL_BROTLI=OFF -D USE_NGHTTP2=OFF -D USE_LIBIDN2=OFF -D BUILD_CURL_EXE=OFF -D BUILD_EXAMPLES=OFF -D BUILD_LIBCURL_DOCS=OFF -D BUILD_MISC_DOCS=OFF -D BUILD_TESTING=OFF -D CURL_ENABLE_SSL=ON -D CURL_USE_OPENSSL=ON -D ENABLE_CURL_MANUAL=OFF -D PICKY_COMPILER=OFF -D CURL_USE_LIBPSL=OFF -D CURL_USE_LIBSSH2=OFF
cmake --build build --config Debug
cmake --install build

# Copy over the built files
cp build/lib/libcurl-d.so upload/Debug

# Clean up before we run CMake again
rm -rf build

# Build Release configuration
cmake -S curl -B build -D CMAKE_BUILD_TYPE=Release -D CURL_ZLIB=OFF -D CURL_ZSTD=OFF -D CURL_BROTLI=OFF -D USE_NGHTTP2=OFF -D USE_LIBIDN2=OFF -D BUILD_CURL_EXE=OFF -D BUILD_EXAMPLES=OFF -D BUILD_LIBCURL_DOCS=OFF -D BUILD_MISC_DOCS=OFF -D BUILD_TESTING=OFF -D CURL_ENABLE_SSL=ON -D CURL_USE_OPENSSL=ON -D ENABLE_CURL_MANUAL=OFF -D PICKY_COMPILER=OFF -D CURL_USE_LIBPSL=OFF -D CURL_USE_LIBSSH2=OFF
cmake --build build --config Release
cmake --install build

# Copy over the built files
cp build/lib/libcurl.so upload/Release

# Copy over the headers
cp -r curl/include/curl/. upload/include/curl
