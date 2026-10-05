# Linux Laptop Optimizations & Network Fixes

Comprehensive guide on hardware tuning, power management, memory optimization, and fixes for dropped/broken Wi-Fi and browser downloads on Ubuntu/Debian.

---

## 1. Fixing Broken Downloads & Wi-Fi Drops

### Issue 1: Intel Wi-Fi Power Saving Sleep Cycles
- **Symptom:** Wi-Fi randomly drops, download speeds throttle, or transfers stop midway during large downloads.
- **Root Cause:** Intel CNVi / Wi-Fi (`iwlwifi` driver) aggressively puts the wireless radio into low-power states (D0i3 / uAPSD) when NetworkManager has power-saving enabled (`wifi.powersave = 3`).
- **Fix:**
  ```bash
  # 1. Disable NetworkManager Wi-Fi power saving
  sudo sed -i 's/wifi.powersave = .*/wifi.powersave = 2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf

  # 2. Disable kernel iwlwifi module power management
  echo "options iwlwifi power_save=0" | sudo tee /etc/modprobe.d/iwlwifi.conf

  # 3. Restart NetworkManager
  sudo systemctl restart NetworkManager

  # Verify (should report 'Power save: off')
  iw dev $(ip -o link show | awk -F': ' '{print $2}' | grep -E '^wl' | head -n1) get power_save
  ```

### Issue 2: IPv6 Path MTU Black Holes & HTTP/3 QUIC Drops (Firefox / CDN Downloads)
- **Symptom:** `curl` or single-stream downloads work, but Firefox downloads stall and fail consistently around 50–90 MB on CDNs (Microsoft, Cloudflare, etc.).
- **Root Cause:**
  1. **IPv6 Path MTU Black Hole:** Residential ISPs/routers often drop large IPv6 packets without returning ICMPv6 fragmentation alerts. Dual-stack systems ("Happy Eyeballs" RFC 8305) prefer IPv6 by default, causing streams to collapse when reaching MTU thresholds.
  2. **HTTP/3 QUIC (UDP):** Firefox uses HTTP/3 over UDP for major CDNs. Router NAT state tables and socket buffers frequently timeout or drop sustained UDP bursts.
- **Fix:**
  ```bash
  # 1. Prefer stable IPv4 system-wide
  sudo sed -i 's/#precedence ::ffff:0:0\/96  100/precedence ::ffff:0:0\/96  100/' /etc/gai.conf 2>/dev/null || echo "precedence ::ffff:0:0/96 100" | sudo tee -a /etc/gai.conf

  # 2. Enable TCP MTU black-hole probing
  echo "net.ipv4.tcp_mtu_probing = 1" | sudo tee -a /etc/sysctl.d/99-laptop-tuning.conf
  sudo sysctl -w net.ipv4.tcp_mtu_probing=1

  # 3. Optimize Firefox profile (add to user.js)
  # Path: ~/snap/firefox/common/.mozilla/firefox/<profile>/user.js (or ~/.mozilla/firefox/<profile>/user.js)
  cat << 'EOF' >> ~/.mozilla/firefox/*.default*/user.js
  // Force reliable TCP/HTTP2 (prevents HTTP/3 QUIC UDP drops on CDNs)
  user_pref("network.http.http3.enable", false);

  // Prefer stable IPv4 for downloads to bypass ISP IPv6 PMTU black holes
  user_pref("network.dns.disableIPv6", true);
  user_pref("network.process.enabled", false);

  // Optimize network socket timeouts & keepalive
  user_pref("network.http.response.timeout", 600);
  user_pref("network.http.tcp_keepalive.short_lived_connections", 1);
  user_pref("network.http.tcp_keepalive.short_lived_time", 60);
  user_pref("network.http.tcp_keepalive.long_lived_connections", 1);
  user_pref("network.http.tcp_keepalive.long_lived_time", 60);
  EOF
  ```

---

## 2. Power & Display Management (Prevent Sleep & Screen Off)

### Prevent Screen Blanking and Sleep on AC Power
```bash
# Never turn off / blank screen
gsettings set org.gnome.desktop.session idle-delay 0

# Disable inactive sleep when plugged in
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
```

### Prevent Laptop from Sleeping When Lid Is Closed
```bash
# GNOME desktop action
gsettings set org.gnome.settings-daemon.plugins.power lid-close-ac-action 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power lid-close-battery-action 'nothing'

# Systemd logind system-wide policy
sudo mkdir -p /etc/systemd/logind.conf.d
sudo tee /etc/systemd/logind.conf.d/99-lid-ignore.conf << 'EOF'
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
EOF
sudo systemctl restart systemd-logind
```

---

## 3. System & Hardware Performance Tuning

### ZRAM Compressed RAM Swap (Essential for 8 GB RAM)
Creates a fast in-memory compressed RAM swap pool (using `zstd`), preventing system freezes and NVMe wear during high memory usage.
```bash
sudo apt install -y zram-tools
sudo sed -i 's/#ALGO=lzo/ALGO=zstd/' /etc/default/zramswap
sudo sed -i 's/#PERCENT=50/PERCENT=60/' /etc/default/zramswap
sudo systemctl restart zramswap

# Verify
swapon --show
```

### Intel GPU Hardware Video Acceleration (VA-API)
Offloads H.264, VP9, and HEVC video decoding from the CPU to Intel UHD graphics:
```bash
sudo apt install -y intel-media-va-driver-non-free vainfo
vainfo
```

### Kernel Memory & TCP BBR Congestion Control
Optimizes directory caching, smooth NVMe dirty memory writebacks, and Google BBR TCP throughput:
```bash
sudo tee /etc/sysctl.d/99-laptop-tuning.conf << 'EOF'
# Keep directory & file cache longer in RAM
vm.vfs_cache_pressure = 50

# Smooth background page flushes to NVMe
vm.dirty_background_ratio = 5
vm.dirty_ratio = 10

# Google BBR TCP Congestion Control
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_mtu_probing = 1
EOF

sudo sysctl --system
```

### Boot Speed & Background Services Optimization
```bash
# Disable kdump-tools (saves ~29s CPU boot time & 512MB reserved RAM)
sudo systemctl disable --now kdump-tools

# Disable wait-online (saves ~6s boot delay on desktop)
sudo systemctl disable NetworkManager-wait-online.service

# Disable Apport crash reporter popups
sudo systemctl disable --now apport
sudo sed -i 's/enabled=1/enabled=0/' /etc/default/apport 2>/dev/null || true
```

### Storage & Log Retention Limits
```bash
# Reduce snap version retention to 2 (saves disk space)
sudo snap set system refresh.retain=2

# Cap systemd journal logs to 200MB
sudo mkdir -p /etc/systemd/journald.conf.d
sudo tee /etc/systemd/journald.conf.d/max-size.conf << 'EOF'
[Journal]
SystemMaxUse=200M
EOF
sudo systemctl restart systemd-journald

# Configure Docker daemon log rotation (max 20MB x 3 files)
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json << 'EOF'
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "20m",
    "max-file": "3"
  }
}
EOF
sudo systemctl restart docker 2>/dev/null || true
```

### Passwordless Sudo for User
```bash
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
sudo chmod 0440 /etc/sudoers.d/$USER
```
