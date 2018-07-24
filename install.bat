@echo off

set windeploypath=%1
set qmldir=%2

if "%windeploypath%"=="" (
	echo No path provided for windeployqt.exe
	set /P windeploypath="Where is windeployqt.exe ? "
)

if not exist "%windeploypath%" (
	echo %windeploypath% don't exist
	pause
	exit
)

if "%qmldir%"=="" (
	echo No path provided for Qt qml directory
	set /P qmldir="Where is Qt qml directory ? "
)

if not exist "%qmldir%" (
	echo %qmldir% don't exist
	pause
	exit
)

echo Deploying Qt application
xcopy ressources\binaries\* packages\com.vendor.product\data /E /Y /C
cd packages/com.vendor.product/data/
"%windeploypath%" PasswordChest.exe --release --qmldir="%qmldir%"
cd ..\..\..
echo Application deployed

set bincreapath=%3

if "%bincreapath%"=="" (
	echo No path provided for binarycreator.exe
	set /P bincreapath="Where is binarycreator.exe ? "
)

if not exist "%bincreapath%" (
	echo %bincreapath% don't exist
	pause
	exit
)

echo Creating the PasswordChestInstaller.exe
"%bincreapath%" -c config\config.xml -p packages PasswordChestInstaller.exe
echo Installer successfully created

pause