@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

choco feature enable -n allowGlobalConfirmation

REM --ignore-dependencies = -i

choco install git
choco install vscode
choco install golang
choco install dotnet-sdk
choco install python3 --params "/NoLockdown"
choco install openjdk
choco install nodejs
choco install totalcommander
choco install processhacker
choco install googlechrome
choco install microsoft-teams
REM https://www.moo0.com/?top=https://www.moo0.com/software/SystemMonitor/

choco install mousewithoutborders
choco install adwcleaner
choco install autohotkey
choco install steam

REM choco install nvidia-display-driver
REM this choco is a pain

choco install paint.net
choco install filezilla
choco install vlc
choco install 7zip
choco install cygwin
choco install crystaldiskmark
choco install openconnect-gui
choco install treesizefree
choco install dbeaver
choco install pgadmin4
choco install s3browser
choco install cmake --installargs 'ADD_CMAKE_TO_PATH=System'
choco install minecraft
choco install dws.portable
choco install openvpn
choco install rustup.install
choco install androidstudio
choco install julia
choco install r.project --params "'/AddToPath'"
choco install visualstudio2019buildtools
choco install kotlinc
choco install adb
choco install make
choco install cheatengine

REM Twitch
choco install chatterino7
choco install streamlink
choco install streamlink-twitch-gui

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
