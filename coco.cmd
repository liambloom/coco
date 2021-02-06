@echo off

perl coco %*
exit /b

:: This Source Code Form is subject to the terms of the Mozilla Public
:: License, v. 2.0. If a copy of the MPL was not distributed with this
:: file, You can obtain one at https://mozilla.org/MPL/2.0/.

cmd /c "exit 0"
setlocal enabledelayedexpansion

call :%*
exit /b

:: https://docs.microsoft.com/en-us/troubleshoot/windows-client/shell-experience/command-line-string-limitation
:list
    for /f "delims=" %%i in ('dir /s /b src ^| findstr /e \.java') do if "!sourcefile!"=="" (set sourcefile=%%i) else (set sourcefile=!sourcefile! %%i)
    echo !sourcefile!
    javac -cp "lib;out" -sourcepath src -d out !sourcefile!
    exit /b

:build
    :: echo %1
    if "%1"=="" (
        ::dir /s /b src | findstr /e \.java > temp
        ::set sourcefile=@temp
        for /f "delims=" %%i in ('dir /s /b src ^| findstr /e \.java') do if "!sourcefile!"=="" (set sourcefile=%%i) else (set sourcefile=!sourcefile! %%i)
        echo !sourcefile!
        goto :build_inner
    )

    set filepath=%1
    set filepath=%filepath:.=\\%
    set sourcefile=src\\%filepath%.java
    set targetfile=out\\%filepath%.class
    
    FOR %%i IN (%soucefile%) DO SET sourceAge=%%~ti
    FOR %%i IN (%targetfile%) DO SET targetAge=%%~ti

    if "%sourceAge%"=="%targetAge%" goto :build_inner

    FOR /F %%i IN ('DIR /B /O:D %soucefile% %targetfile%') DO SET NEWEST=%%~xi
    if "%NEWEST%"==".class" exit /b

    :build_inner
        echo building...%filepath%
        javac -cp "lib;out" -sourcepath src -d out !sourcefile!
        ::if "%sourcefile%"=="@temp" del temp
        exit /b

:run
    :: echo %*
    :: Do something with args
    call :build %* && java -cp "lib;out" %1
    exit /b

:help
    echo "No help for you"
    exit /b