# 🔒 TorGuard Custom WireGuard App for OpenWRT  

## 🌍 Overview  
The **TorGuard Custom WireGuard App for OpenWRT** makes it simple and easy to paste any **WireGuard config** from the **TorGuard WireGuard Config Generator**.  

This is ideal for **custom WireGuard setups**, including:  
✅ **Dedicated IPs**  
✅ **Residential IPs**  
✅ **TorGuard's Private VPN Cloud (Dedicated WireGuard Service)**  

### 🆕 **Latest Updates (v2.0.9-r0)**  
🚀 **New Features & Fixes:**  
✅ **Enable/Disable "Start at Boot"** – Ensures VPN auto-connects when the router reboots.  
✅ **Fixed WAN Disconnection Issue** – Improved network stability after VPN disconnections.  
✅ **Connection Status Display** – Easily check if the VPN is connected or disconnected.  
✅ **RX/TX Traffic Info** – View real-time upload and download traffic statistics for WireGuard.  

This app is **officially maintained by TorGuard** to provide a seamless WireGuard experience on OpenWRT.  

---

## 📥 Installation Methods  

### 🏗️ Compile from Source using OpenWRT SDK  

Follow these steps to build the package from source:  

1️⃣ **Navigate to OpenWRT SDK Directory**  
```bash
cd ~/openwrt/package
```
*(Ensure you have the OpenWRT SDK set up beforehand.)*  

2️⃣ **Clone the Repository**  
```bash
git clone https://github.com/TorGuard/tgwireguard.git
```

3️⃣ **Compile the Package**  
```bash
cd ~/openwrt
make package/tgwireguard/compile V=s
```

4️⃣ **Locate the `.ipk` File**  
After compilation, the package will be found in:  
```
~/openwrt/bin/packages/<target_architecture>/base/tgwireguard.ipk
```
*(Replace `<target_architecture>` with your OpenWRT device's architecture.)*  

---

### 📦 Install Precompiled `.ipk` Package  

#### 🖥️ Method 1: Upload via OpenWRT Web UI  
1️⃣ **Download the `.ipk` file** from the [GitHub Releases](https://github.com/TorGuard/tgwireguard/releases).  
2️⃣ Log into **OpenWRT Web Interface**.  
3️⃣ Navigate to **System ⚙️ → Software**.  
4️⃣ Click **Upload Package**, select the `.ipk` file, and click **Install**.  

---

#### ⏬ Method 2: Install via `wget` (SSH)  
1️⃣ **SSH into your OpenWRT router**  
```bash
ssh root@192.168.1.1
```

2️⃣ **Download and Install the Package**  
```bash
cd /tmp
wget https://github.com/TorGuard/tgwireguard/releases/latest/download/tgwireguard.ipk
opkg install tgwireguard.ipk
```

---

## 🚀 Usage  

1️⃣ Open the **TorGuard WireGuard App** in OpenWRT.  
2️⃣ **Paste your WireGuard configuration** (from the TorGuard WireGuard Config Generator).  
3️⃣ Click **Connect** to establish a WireGuard VPN tunnel.  
4️⃣ (Optional) **Enable "Start at Boot"** to keep the VPN active after reboots.  

---

## 🔗 Support & Updates  
This OpenWRT app is **officially maintained by TorGuard**.  
📞 **Support:** [TorGuard Support](https://torguard.net/)  
📢 **Latest Releases:** [GitHub Releases](https://github.com/TorGuard/tgwireguard/releases)  

---

**Enjoy seamless and secure WireGuard VPN on OpenWRT with TorGuard!** 🎉🔒  
