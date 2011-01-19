@ECHO off
SETLOCAL
ECHO Building webcache...
ECHO --Cleaning up.  Safe to ignore "cannot find" messages.
rmdir /s /q tmp\war 
rmdir /s /q public
ECHO --Building deployable war file
.\build\bin\warble.bat