@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

choco feature enable -n allowGlobalConfirmation

choco install git
choco install vscode
choco install golang
choco install gnuwin32-make.portable
choco install docker-for-windows
REM Better override then with the latest version
choco install openvpn

choco install dws.portable
choco install googlechrome
choco install totalcommander
choco install processhacker

choco install jdk10
choco install -i maven
choco install -i eclipse

choco install anaconda3 --params="/AddToPath:1"

choco install adb

choco install nodejs
choco install meteor

choco install robo3t

choco install cmake --installargs 'ADD_CMAKE_TO_PATH=System'
choco install rust

choco install sandboxie

choco install photofiltre7

choco install mingw

choco install sysinternals

REM choco install geforce-game-ready-driver

cup all
