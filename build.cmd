@echo off

:: configure following 2 vars to make it work:
:: 1. specify the path where vcvars*.bat files are located
SET "VsPath=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build"
:: 2. specify the path where you installed the Mozilla Build suite
::    (https://wiki.mozilla.org/MozillaBuild)
SET "MozBuild=c:\mozilla-build"


SET Target=nss_build_all
IF "%1" NEQ "" SET Target=%1

SET "CommonOpt=OS_TARGET=WIN95 USE_STATIC_RTL=1"
SET "ReleaseOpt=BUILD_OPT=1"
SET "DebugOpt=USE_DEBUG_RTL=1"

SET "Bash=%MozBuild%\msys\bin\bash --login -i -c"
SET "SrcDir=%~dp0nss"
SET "MOZILLABUILD=%MozBuild%\"

SET "PATH=%PATH%;%MOZILLABUILD%moztools-x64\bin"

:: 32-bit builds
CALL "%VsPath%\vcvars32.bat"
IF %errorlevel% NEQ 0 EXIT %errorlevel%

%BASH% "cd '%SrcDir%'; %CommonOpt% %DebugOpt% make %Target%"
IF %errorlevel% NEQ 0 EXIT %errorlevel%

%BASH% "cd '%SrcDir%'; %CommonOpt% %ReleaseOpt% make %Target%"
IF %errorlevel% NEQ 0 EXIT %errorlevel%

:: fix: these misplaced objs cause a build with a different arch to fail
del nss\lib\ckfw\builtins\testlib\*.obj

:: 64-bit builds
SET "CommonOpt=%CommonOpt% USE_64=1"

CALL "%VsPath%\vcvars64.bat"
IF %errorlevel% NEQ 0 EXIT %errorlevel%

%BASH% "cd '%SrcDir%'; %CommonOpt% %DebugOpt% make %Target%"
IF %errorlevel% NEQ 0 EXIT %errorlevel%

%BASH% "cd '%SrcDir%'; %CommonOpt% %ReleaseOpt% make %Target%"
IF %errorlevel% NEQ 0 EXIT %errorlevel%

:: fix: these misplaced objs cause a build with a different arch to fail
del nss\lib\ckfw\builtins\testlib\*.obj
