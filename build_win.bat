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

echo Downloading curl...
powershell -command "(new-object System.Net.WebClient).DownloadFile('https://curl.se/download/curl-8.12.1.zip','curl.zip')"

dir

:end
echo Done.
exit /b
