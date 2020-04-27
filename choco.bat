@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

choco feature enable -n allowGlobalConfirmation

choco install git
choco install vscode
choco install golang
choco install make
choco install dws.portable
choco install totalcommander
choco install processhacker
choco install openvpn
choco install nodejs
choco install python3

choco install windirstat
choco install filezilla
choco install adb
choco install sandboxie
choco install photofiltre7
choco install adwcleaner

REM choco install 7zip
REM choco install adoptopenjdk11
REM choco install -i maven
REM choco install -i eclipse
REM choco install mingw
REM choco install cmake --installargs 'ADD_CMAKE_TO_PATH=System'
REM choco install rust
REM choco install sysinternals
REM choco install nssm
REM choco install greenshot
REM choco install meteor
REM choco install robo3t
REM REM choco install anaconda3 --params="/AddToPath:1"
REM REM choco install docker-for-windows

cup all
