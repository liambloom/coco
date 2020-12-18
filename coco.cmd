@echo off

:: This Source Code Form is subject to the terms of the Mozilla Public
:: License, v. 2.0. If a copy of the MPL was not distributed with this
:: file, You can obtain one at https://mozilla.org/MPL/2.0/.

cmd /c "exit 0"

setlocal

if "%1"=="" goto :help
FOR %%G IN ("build"
     "run"
     "help") DO (
    IF /I "%1"=="%%~G" goto run
)

echo Error: Command `%1' unknown
exit /b

:run
goto :%1

rem Make sure to pass in argument to the target as well

:build
    rem if "%2"=="" build everything

    rem there must be an easier way to do this
    set filepath=%2
    set filepath=%filepath:.=\\%
    set sourcefile=src\\%filepath%.java
    set targetfile=out\\%filepath%.class
    
    FOR %%i IN (%soucefile%) DO SET sourceAge=%%~ti
    FOR %%i IN (%targetfile%) DO SET targetAge=%%~ti

    if "%sourceAge%"=="%targetAge%" goto :build_always

    FOR /F %%i IN ('DIR /B /O:D %soucefile% %targetfile%') DO SET NEWEST=%%~xi
    echo %NEWEST%
    if "%NEWEST%"==".class" exit /b

    :build_always
        echo building...
        javac -cp "lib;out" -sourcepath src -d out %sourcefile%
        exit /b

:run
    call :build %* && java -cp "lib;out" %2 
    exit /b

:help
    echo "No help for you"
    exit /b

:setAge
    FOR %%i IN (%~1) DO SET %~2=%%~ti
    exit /b