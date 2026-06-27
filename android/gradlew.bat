@echo off
setlocal
set DIR=%~dp0
set JAR_PATH=%DIR%gradle\wrapper\gradle-wrapper.jar
if not exist "%JAR_PATH%" (
  echo Error: Could not find gradle wrapper jar at %JAR_PATH%
  exit /b 1
)
"%JAVA_HOME%\bin\java" -jar "%JAR_PATH%" %*
