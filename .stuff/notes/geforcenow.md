# GeForce NOW over Cellular Tethering (Laptop + OnePlus)

Everything below was applied and measured on 2026-11-05/06 on the reference setup.
Items are marked **[measured]** when a number backs them, **[applied, unverified]**
when they are safe but had no measurable effect, and **[dead end]** when proven
not to work on this hardware.

## Reference setup

| | |
|---|---|
| Laptop | ASUS Vivobook S 14 M3407HA |
| CPU / GPU | Ryzen 9 270 (8C/16T) / Radeon 780M (drv 32.0.32015.7029) |
| RAM | 32 GB DDR5-5600 |
| Panel | 2560x1600 @ **60.000 Hz**, HDR **not supported** (`dxdiag` native mode) |
| Wi-Fi | MediaTek MT7920, 2x2 Wi-Fi 6, 5 GHz ch149 @ 80 MHz |
| Phone | OnePlus 13 (CPH2653), OxygenOS 16 / Android 16 |
| Uplink | EE eSIM, NR-SA, `ssRsrp = -101 dBm` |
| GFN client | 2.0.90.126 (`%LOCALAPPDATA%\NVIDIA Corporation\GeForceNOW`) |

**The panel is the hard ceiling**: 16.7 ms frame at 60 Hz + ~10 ms decode ≈ 27 ms
that no network change can remove. GFN Ultimate 4K120/HDR is unreachable here;
1600p60 SDR is the target.

## Measured results

| Path | LAN RTT (laptop→phone) | → 1.1.1.1 | Under full download | Throughput |
|---|---|---|---|---|
| Wi-Fi hotspot, before tweaks | 6.3 ms, jitter 1.7 | 46 ms | **max 76 ms** LAN / 68 WAN | 256 Mbit/s |
| Wi-Fi hotspot, after tweaks | 4.8 ms, max 13 | 44.5 ms, max 72 | — | 452 Mbit/s (ax, 1.2 Gbps link) |
| **USB / RNDIS ethernet** | **1.3 ms, jitter 0.6, max 4** | **32.4 ms** | **max 18 ms LAN / 49 WAN** | 255 Mbit/s |
| GFN UK zone (TCP 443 timing) | — | 24–30 ms (8/8 connects) | — | — |

End-to-end estimate: `1.3 + 30 + 16.7 frame + ~10 decode ≈ 58 ms`. Of that, ~1.3 ms
is under your control.

**Conclusion: prefer USB tethering.** Same average latency, but 18 ms worst case
vs 76 ms under load — that tail is what stutters.

## 1. Find the real topology first

The "router" is usually the phone itself. Confirm before tuning anything:

```bash
# AP interface, channel, standard, and whether it's already Wi-Fi 6
adb shell 'dumpsys wifi | grep -m1 mCurrentSoftApInfoMap'
#   → {wlan2=SoftApInfo{bandwidth=4, frequency=5745, wifiStandard=6, ...}}
#   frequency 5745 = ch149; wifiStandard 6 = 802.11ax

# Which interface is the NAT upstream (cellular vs Wi-Fi uplink)
adb shell 'dumpsys tethering | grep -E "Current upstream|Client Information"'
adb shell 'ip route; ip neigh'      # laptop must appear as a neighbour
```

Laptop side: `netsh wlan show interfaces` — `AP BSSID` is the phone's SoftAP MAC,
derived from the Wi-Fi chip MAC with the locally-administered bit set
(`14:92:39:…` → `16:92:39:…`). If it matches, the phone is your AP.

## 2. Windows laptop

### Route preference (needed when both paths are up) **[measured]**
Auto-metric does not respond to `-InterfaceMetric` alone; disable automatic first.

```powershell
$eth  = (Get-NetAdapter | Where-Object {$_.InterfaceDescription -like "*NDIS*"}).ifIndex
$wifi = (Get-NetAdapter -Name "WiFi").ifIndex
Set-NetIPInterface -InterfaceIndex $eth  -AutomaticMetric Disabled -InterfaceMetric 1
Set-NetIPInterface -InterfaceIndex $wifi -AutomaticMetric Disabled -InterfaceMetric 50
# verify: (Find-NetRoute -RemoteIPAddress 1.1.1.1)[0].InterfaceAlias  → "Ethernet 2"
```

### Wi-Fi power saving **[applied, unverified]**
`powercfg` is the real knob on MT7920 — the "Power Saving" advanced property the
old version of this note mentioned does not exist on this driver.

```powershell
powercfg /setacvalueindex SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
powercfg /setdcvalueindex SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
powercfg /setactive SCHEME_CURRENT
# revert: same command with value 3
```
Measured: no change under load (63→76 ms spikes, noise). Kept as hygiene only.

### Defender exclusion **[measured: removes the top CPU consumer during play]**
```powershell
Add-MpPreference -ExclusionPath "$env:LOCALAPPDATA\NVIDIA Corporation\GeForceNOW"
```

### QoS DSCP 46 for the client **[applied, unverified]**
Only pays off if the AP honours WMM/AC_VO. Harmless otherwise.
```powershell
New-NetQosPolicy -Name "GeForceNOW-UDP" `
  -AppPathNameMatchCondition "$env:LOCALAPPDATA\NVIDIA Corporation\GeForceNOW\CEF\GeForceNOW.exe" `
  -DSCPAction 46 -NetworkProfile All
# remove: Remove-NetQosPolicy -Name "GeForceNOW-UDP" -Confirm:$false
```

### Already-correct defaults (don't touch)
- Power plan: **Ultimate Performance**
- Hardware-accelerated GPU scheduling (`HwSchMode=2`), Game Mode on, GameDVR off
- Startup list is already minimal (`AMDNoiseSuppression`, `SecurityHealth`)

### Do NOT bother
- **MMCSS tweaks** (`SystemResponsiveness`, `NetworkThrottlingIndex=0xFFFFFFFF`,
  Games task priority): not applied here, no evidence for a video-decode workload.
- **`netsh wlan set autoconfig enabled=no`**: kills the ability to join new
  networks and is pointless once ethernet is primary.
- Disabling Hyper-V/VBS: `vmms` + `WslService` are up for WSL2. ~2–5% CPU at the
  cost of breaking WSL.
- IFEO high-priority for the client; MediaTek `LowPowerEnable` registry hacks.

## 3. GeForce NOW client (JSON, client must be closed)

Values live in `%LOCALAPPDATA%\NVIDIA Corporation\GeForceNOW\sharedstorage.json`
under `appSettingsConfig.customProfile`. The client rewrites the file on exit, so
close it first.

```powershell
$f = "$env:LOCALAPPDATA\NVIDIA Corporation\GeForceNOW\sharedstorage.json"
Copy-Item $f "$f.bak" -Force
$raw = Get-Content $f -Raw
# surgical, single-occurrence replacements to keep the rest of the file intact
$new = [regex]::Replace($raw, '("maxBitrate":\s*)100', '${1}50', 1)
$new = [regex]::Replace($new, '("bitDepth":\s*)10',  '${1}8',  1)
[IO.File]::WriteAllText($f, $new)     # WriteAllText → no BOM (Chromium JSON parser)
```

Target state (verify after relaunch):

| Key | Value | Why |
|---|---|---|
| `width` x `height` | 2560 x 1600 | Native, no upscaling |
| `fps` | 60 | Panel is 60 Hz; 120 only buys judder |
| `maxBitrate` / `maxBitrateAuto` | 50 / false | 1600p60 8-bit needs ~40–50; 100 just fills the AP queue |
| `bitDepth` | **8** | 10-bit on an 8-bit SDR panel wastes ~20% bitrate |
| `hdrStreamingMode` | OFF | Panel reports no HDR |
| `vSync` | 2 | Keep; in-game VSync OFF |
| `codec` | 0 (auto) | Let it pick AV1/H.264 |
| `l4sEnabled` | false | Carrier does not handle L4S ECN |
| `maxPacketSize` | 1416 | Safe under the 1500 path MTU (measured) |
| `reflex` | false → **true** optional | Only affects games that implement it |

UI equivalents: Settings → Streaming Quality → Custom, with the same numbers.

### Frame decoupling (optional, unverified here)
Stream 60 FPS while the cloud rig renders 120 FPS + Reflex ON. Keeps video
smooth over a thin pipe while input stays responsive.

## 4. Phone — OnePlus 13 / OxygenOS 16

All settings survive a reboot (they are in the global settings DB).

```bash
adb shell '
settings put global low_power 0                      # battery saver OFF (was 1: throttles CPU + Wi-Fi TX)
settings put global wifi_scan_always_enabled 0       # no scan time-slicing on the AP channel
settings put global ble_scan_always_enabled 0
settings put global soft_ap_wifi6_state 1            # 802.11ac hotspot → 802.11ax
settings put global soft_ap_timeout_enabled 0        # hotspot will not auto-off mid-session
'
```

Verify:
```bash
adb shell 'dumpsys wifi | grep -m1 mCurrentSoftApInfoMap'   # wifiStandard=6, frequency=5745
adb shell 'dumpsys power | grep -m1 mSettingBatterySaverEnabled'   # false
```

The Wi-Fi 6 hotspot only applies after a **re-association** — toggle laptop Wi-Fi
(or the hotspot) once. Measured after reconnect: 866 → 1202 Mbit/s link.

Other phone levers:
- Keep it plugged in; check `dumpsys thermalservice | grep "Thermal Status"` (0 = fine).
- `bypass_charge_state` / `bypass_charge_value=80` exist (`settings list global`)
  to run off USB power instead of cycling the cell — reduces heat on multi-hour
  sessions. Not applied here.
- `settings list system | grep smart5g_basic_cfg` shows `hotspot_enable=0`:
  OnePlus' Smart 5G LTE-fallback is disabled **while tethering**, so the link
  won't silently demote to LTE mid-session.

## 5. Verified dead ends (don't retry)

| Attempt | Result |
|---|---|
| `svc usb setFunctions rndis,adb` | `Killed` — OEM blocks the USB function switch; enable USB tethering from Settings instead |
| `cmd phone set-allowed-network-types-for-users …` | `No valid NETWORK_TYPES_BITMASK` for names, subsets, `4096`, `0x1000` |
| `am start -n com.android.settings/.RadioInfo` | Activity does not exist |
| `settings put global preferred_network_mode2 11` | Written, modem ignores it (stays NR_SA); read at boot only |
| Settings UI → "Preferred network type" | Not exposed anywhere in the SIM/eSIM tree on OxygenOS 16 |
| ICMP to `*.cloudmatchbeta.nvidiagrid.net` | Blocked — use TCP 443 connect timing instead |
| 3G-era "start a call to lower latency" | Obsolete: that pinned UMTS DCH. LTE/NR RRC is already held by the UDP stream; a VoLTE call now competes with it |

## 6. Measurement recipes

**LAN RTT + jitter to the AP** (jitter = mean absolute delta between samples):
```powershell
$gw = (Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Sort-Object RouteMetric)[0].NextHop
$r = Test-Connection -ComputerName $gw -Count 25
$lat = @($r.ResponseTime); $s = 0
for ($i=1; $i -lt $lat.Count; $i++) { $s += [math]::Abs($lat[$i]-$lat[$i-1]) }
"min=$(($lat|Measure-Object -Minimum).Minimum) avg=$([math]::Round(($lat|Measure-Object -Average).Average,1)) max=$(($lat|Measure-Object -Maximum).Maximum) jitter=$([math]::Round($s/$lat.Count,1))"
```

**Bufferbloat** (the number that matters — run a download and ping at once):
```powershell
$tmp=[IO.Path]::GetTempFileName()
$p = Start-Process curl.exe -ArgumentList "-s -o `"$tmp`" --max-time 40 https://proof.ovh.net/files/100Mb.dat" -PassThru -WindowStyle Hidden
Start-Sleep 2; ping -n 15 1.1.1.1
Stop-Process -Id $p.Id -Force; Remove-Item $tmp
```

**Path MTU** (1500 confirmed on EE):
```powershell
ping -n 1 -f -l 1472 1.1.1.1
```

**GFN zone RTT** (ICMP is blocked; TCP connect timing is the proxy):
```powershell
$ip = (Resolve-DnsName eu-united-kingdom-1.cloudmatchbeta.nvidiagrid.net -Type A).IPAddress[0]
$lat = @()
for ($i = 0; $i -lt 8; $i++) {
  $sw = [Diagnostics.Stopwatch]::StartNew(); $t = New-Object Net.Sockets.TcpClient
  $ar = $t.BeginConnect($ip, 443, $null, $null)
  if ($ar.AsyncWaitHandle.WaitOne(1500)) { $t.EndConnect($ar); $sw.Stop(); $lat += [int]$sw.ElapsedMilliseconds }
  $t.Dispose()
}
"min=$(($lat|Measure-Object -Minimum).Minimum) avg=$([math]::Round(($lat|Measure-Object -Average).Average)) max=$(($lat|Measure-Object -Maximum).Maximum)"
```
Historical zone latencies are cached per-network in `networkConfig.networks.*.zonesLatencies`.

## 7. What is actually left

| Lever | Gain | Cost |
|---|---|---|
| Fixed broadband (FTTP) | **−15 to −20 ms** RTT, jitter → <1 ms, uplink scheduling delay gone | ISP contract |
| Phone placement / RX diversity | 5–10 ms if RSRP moves −101 → −95 | Free |
| `bypass_charge_state=1` | Prevents modem throttle at hour 2–3 | Free, reversible |
| 120 Hz+ VRR panel | Removes the 16.7 ms frame floor | New laptop |

Nothing in the OS, driver, client, or phone stack is left worth changing on this
setup — every hop has been measured and accounted for.
