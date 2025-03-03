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

:end
echo Done.
exit /b
