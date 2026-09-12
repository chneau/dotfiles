# GeForce NOW & Mobile Hotspot / USB Optimization Guide

A comprehensive cheatsheet of all system, network, driver, and application tweaks to get ultra-low latency, zero frame drops, and tear-free visuals on GeForce NOW over a mobile phone hotspot / USB tethering (EE 5G / OnePlus).

---

## 1. GeForce NOW Client Settings

Under **Settings** > **Streaming Quality** > **Custom**:
- **Resolution**: Native display resolution (e.g. `2560 x 1600` QHD+ 16:10).
- **Frame Rate**: `60 FPS` (matches 60 Hz display perfectly, cuts cellular packet pressure by 50%).
- **Max Bitrate**: `50 Mbps` (Turn toggle ON and lock slider to 50 Mbps).
- **VSync**: `Adaptive` (prevents horizontal screen tearing and stutter).
- **Codec**: `Auto (AV1)` (most efficient compression/decompression).
- **L4S**: `OFF` (Crucial: mobile carrier networks do not handle L4S ECN marking properly, causing packet drops).
- **Adjust for poor network conditions**: `Optimal latency` (or ON).

### Frame Decoupling (Secret Sauce):
- **Stream**: `60 FPS` (smooth, tear-free video over the wire).
- **In-Game (RTX 4080 Cloud Rig)**: Uncap FPS or set to `120 FPS`, and turn **NVIDIA Reflex** `ON / ON+Boost`.
- You get the instant mouse response of 100+ FPS in the cloud, streamed as a rock-solid 60 FPS video.

---

## 2. Windows Wi-Fi & Network Tweaks (PowerShell Admin)

### Stop Periodic Wi-Fi Background Scanning (Lag Spikes)
Windows scans for SSIDs every 60s, causing 100-300ms packet loss bursts:
```powershell
# Disable background scan while connected:
netsh wlan set autoconfig enabled=no interface="WiFi"

# Re-enable when you need to search for new networks:
netsh wlan set autoconfig enabled=yes interface="WiFi"
```

### Optimize Wi-Fi Adapter Properties (MediaTek / Intel)
```powershell
# Disable roaming aggressiveness (stops card searching for other APs)
Set-NetAdapterAdvancedProperty -Name "WiFi" -DisplayName "Roaming Aggressiveness" -DisplayValue "1. Disabled"

# Disable radio sleep / power saving
Set-NetAdapterAdvancedProperty -Name "WiFi" -DisplayName "Power Saving" -DisplayValue "Disabled"

# Force 5 GHz preference
Set-NetAdapterAdvancedProperty -Name "WiFi" -DisplayName "Preferred Band" -DisplayValue "3. Prefer 5GHz band"
```

### USB Tethering (Remote NDIS Ethernet)
When using USB cable tethering from the phone:
```powershell
# Disable USB Selective Suspend on AC (stops USB port micro-sleeps)
powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
powercfg /setactive SCHEME_CURRENT

# Set highest routing metric priority for USB Ethernet
Set-NetIPInterface -InterfaceAlias "Ethernet" -InterfaceMetric 10

# Set fast Cloudflare DNS
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("1.1.1.1", "1.0.0.1")
```

### Windows QoS DSCP Packet Tagging (Priority Queue)
Puts GFN stream & input packets into the highest hardware priority queue (`WMM AC_VO`):
```powershell
if (-not (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\QoS")) {
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\QoS" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\QoS" -Name "DoNotUseNLA" -Value "1" -Type String

New-NetQosPolicy -Name "GeForceNOW-Priority" -AppPathNameMatchCondition "GeForceNOWStreamer.exe" -DSCPAction 46 -NetworkProfile All
New-NetQosPolicy -Name "GeForceNOW-Client-Priority" -AppPathNameMatchCondition "GeForceNOW.exe" -DSCPAction 46 -NetworkProfile All
```

### Block Background Windows Updates from Stealing Cellular Bandwidth
```powershell
# Mark hotspot profile as Metered (Cost=Fixed)
netsh wlan set profileparameter name="<SSID_NAME>" cost=Fixed

# Disable Delivery Optimization P2P upload seeding
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" -Name "DODownloadMode" -Value 0 -Type DWord
```

---

## 3. Windows Graphics & Power Optimization

### High Performance GPU & Modern DXGI Flip Model
Enables hardware flip model in windowed / borderless modes (ultra-low latency with zero screen tearing):
```powershell
Set-ItemProperty -Path "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences" -Name "DirectXUserGlobalSettings" -Value "SwapEffectUpgradeEnable=1;"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences" -Name "$env:LOCALAPPDATA\NVIDIA Corporation\GeForceNOW\CEF\GeForceNOW.exe" -Value "GpuPreference=2;SwapEffectUpgradeEnable=1;"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences" -Name "$env:LOCALAPPDATA\NVIDIA Corporation\GeForceNOW\CEF\GeForceNOWStreamer.exe" -Value "GpuPreference=2;SwapEffectUpgradeEnable=1;"
```

### MMCSS Gaming Scheduler (100% CPU to Games)
```powershell
# Allocate 100% CPU to foreground game
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF

# Boost gaming thread scheduling
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category" -Value "High"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Value 6
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "SFIO Priority" -Value "High"
```

### AMD Radeon Software (iGPU / dGPU)
- Open AMD Software (`Alt + R` or `Ctrl + Alt + Shift + R`).
- **Gaming** > **Graphics** > **Wait for Vertical Refresh**: Set to **`Always on`** (or `Enhanced Sync` if supported).

---

## 4. Mobile Phone (OnePlus / OxygenOS / 5G Hotspot)

- **Disable Smart 5G**: Settings > Mobile network > More settings > Turn OFF **Smart 5G** (prevents background throttling to 4G).
- **Force 5G Standalone (5G SA)**:
  - Settings > Mobile network > More settings > 5G network mode > Set to **`NSA + SA mode`**.
  - Or via secret dialer menu: Dial `*#*#4636#*#*` > Phone information > Set Preferred Network Type to **`NR only`**.
- **Thermals**: Take phone out of case, place near window/flat hard surface, plugged into charger (avoids modem thermal throttling).
