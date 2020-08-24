@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

choco feature enable -n allowGlobalConfirmation

choco install git
choco install vscode
choco install golang
choco install make
choco install totalcommander
choco install processhacker
choco install nodejs-lts
choco install python3
choco install openjdk11
choco install googlechrome
choco install adb
choco install paint.net
choco install filezilla
choco install openconnect-gui
choco install visualstudio2019buildtools

choco install autohotkey
choco install vlc
choco install adwcleaner
choco install treesizefree
choco install nvidia-display-driver
choco install mousewithoutborders
choco install cheatengine
choco install dbeaver
choco install 7zip


choco install s3browser
choco install cmake --installargs 'ADD_CMAKE_TO_PATH=System'
choco install rainmeter
choco install minecraft
choco install steam
choco install sandboxie
choco install dws.portable
choco install openvpn
choco install rustup.install
choco install androidstudio
choco install julia
choco install cygwin
choco install cyg-get

REM openvpn is not openvpn-connect

REM curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
REM choco install -i maven
REM choco install -i eclipse
REM choco install mingw
REM choco install rust
REM choco install sysinternals
REM choco install nssm
REM choco install greenshot
REM choco install meteor
REM choco install robo3t
REM REM choco install anaconda3 --params="/AddToPath:1"
REM REM choco install docker-for-windows

cup all
