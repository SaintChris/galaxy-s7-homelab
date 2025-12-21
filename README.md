# 📱 S7 Homelab: Turning a Smartphone into a Linux Server

## 🎯 Project Motivation

After completing the **Google IT Support Professional Certificate**, I was eager to apply my skills in a real-world environment. When my primary PC failed, leaving me without a dedicated homelab, I refused to let it stall my progress. This project was born from the need for a **creative, zero-cost solution** to continue learning system administration and web hosting.

## 💡 The Solution

I repurposed a legacy **Samsung Galaxy S7** (Snapdragon 820 / 4GB RAM) into a functional homelab server. Unlike traditional mobile-to-server projects, this was achieved **without rooting** or using custom ROMs, ensuring a stable environment that respects the device's native security while utilizing its Linux kernel via **Termux**.

### Key Technical Achievements:

* **Web Stack:** Running Nginx, PHP 8.4, and MariaDB on an Android-based environment.
* **Security:** Integrated **Cloudflare Turnstile** for bot protection and **Cloudflare Tunnels** to securely expose the site (`https://saintlex.sbs`) without opening local firewall ports.
* **Optimization:** Fine-tuned PHP-FPM and Nginx to handle the hardware constraints of a mobile CPU.

## 🚀 Project Goals

This server serves as my primary learning sandbox. My strict adherence to the following constraints ensures maximum skill growth:

1. **Exclusively Open Source:** Utilizing only free and open-source software (FOSS).
2. **Resource Efficiency:** Mastering the art of "doing more with less" by hosting a live WordPress site on mobile hardware.
3. **End-to-End Hosting:** Managing everything from the local file system (Termux) to global delivery (Cloudflare).

---

## 🛠️ Tech Stack

| Component | Technology |
| --- | --- |
| **Hardware** | Samsung Galaxy S7 (aarch64) |
| **OS Environment** | Android 8.0 + Termux |
| **Web Server** | Nginx |
| **Backend** | PHP 8.4 (FPM) |
| **Database** | MariaDB |
| **CMS** | WordPress |
| **Tunnel/DNS** | Cloudflare Zero Trust |
| **Security** | Cloudflare Turnstile |

---

## 📂 System Structure & Diagnostics

*The system logs and diagnostic audits included in this repository demonstrate the rigorous monitoring I perform to maintain server health on mobile hardware.*

`[Link to your diagnostic files or folder here]`
