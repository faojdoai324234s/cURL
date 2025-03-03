@echo off
setlocal EnableDelayedExpansion

set PROGFILES=%ProgramFiles%
if not "%ProgramFiles(x86)%" == "" set PROGFILES=%ProgramFiles(x86)%

REM Check if Visual Studio 2019 is installed
set MSVCDIR="%PROGFILES%\Microsoft Visual Studio\2019"
set VCVARSALLPATH="%PROGFILES%\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvarsall.bat"
if exist %MSVCDIR% (
  if exist %VCVARSALLPATH% (
   	set COMPILER_VER="2019"
   	set VCVERSION = 15
   	echo Using Visual Studio 2019 Enterprise
	goto begin
  )
)

echo No compiler found : Microsoft Visual Studio 2019 Enterprise is not installed.
goto end

:begin

REM Download latest curl and rename to curl.zip
echo Downloading curl...
powershell -command "(new-object System.Net.WebClient).DownloadFile('https://curl.se/download/curl-8.12.1.zip','curl.zip')"

REM Extract downloaded zip file to tmp_libcurl
"C:\Program Files\7-Zip\7z.exe" x curl.zip -y -otmp_libcurl
del curl.zip

cd tmp_libcurl\curl-*\winbuild

REM Build!
echo "Building libcurl now!"

if [%1]==[-static] (
	set RTLIBCFG=static
	echo Using /MT instead of /MD
) 

echo "Path to vcvarsall.bat: %VCVARSALLPATH%"
call %VCVARSALLPATH% x64

echo Compiling dll-debug-x64 version...
nmake /f Makefile.vc mode=dll VC=%VCVERSION% DEBUG=yes MACHINE=x64 WINBUILD_ACKNOWLEDGE_DEPRECATED=yes

echo Compiling dll-release-x64 version...
nmake /f Makefile.vc mode=dll VC=%VCVERSION% DEBUG=no GEN_PDB=yes MACHINE=x64 WINBUILD_ACKNOWLEDGE_DEPRECATED=yes

echo Compiling static-debug-x64 version...
nmake /f Makefile.vc mode=static VC=%VCVERSION% DEBUG=yes MACHINE=x64 WINBUILD_ACKNOWLEDGE_DEPRECATED=yes

echo Compiling static-release-x64 version...
nmake /f Makefile.vc mode=static VC=%VCVERSION% DEBUG=no MACHINE=x64 WINBUILD_ACKNOWLEDGE_DEPRECATED=yes

cd tmp_libcurl\curl-*\builds
dir /s

:end
echo Done.
exit /b
