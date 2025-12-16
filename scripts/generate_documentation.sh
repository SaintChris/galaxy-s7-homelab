#!/data/data/com.termux/files/usr/bin/bash

echo "# Galaxy S7 Homelab - Full Documentation Generator"
echo "=================================================="
echo ""
echo "📋 Gathering system information..."
echo ""

# 1. System Information
echo "## 1. System Information"
echo '```bash'
uname -a
echo ""
echo "Termux version:"
pkg list-installed | grep -i termux
echo ""
echo "Free space:"
df -h $HOME
echo '```'
echo ""

# 2. Installed Packages
echo "## 2. Installed Packages"
echo '```bash'
pkg list-installed | head -30
echo "..."
echo '```'
echo ""

# 3. Project Structure
echo "## 3. Project Structure"
echo '```bash'
tree ~ -L 2 -I 'node_modules|__pycache__|.git' 2>/dev/null || find ~ -maxdepth 2 -type f -name "*.sh" -o -name "*.py" -o -name "*.js" -o -name "*.json" | head -30
echo '```'
echo ""

# 4. Key Scripts Content
echo "## 4. Key Scripts"
for script in manage_server.sh encrypted_backup.sh cf_tunnel.sh setup_cloudflare_complete.sh; do
    if [ -f ~/$script ]; then
        echo "### $script"
        echo '```bash'
        head -50 ~/$script
        echo '```'
        echo ""
    fi
done

# 5. Services Status
echo "## 5. Running Services"
echo '```bash'
ps aux | grep -E "nginx|php|python|node|ssh" | grep -v grep
echo ""
netstat -tuln | grep -E ':80|:443|:8080|:8443|:8022|:3001'
echo '```'
echo ""

# 6. Cloudflare Setup Attempts
echo "## 6. Cloudflare Tunnel Issues & Solutions"
echo "### Problems Encountered:"
echo "1. DNS resolution failure: \`[::1]:53: connection refused\`"
echo "2. API authentication errors due to DNS"
echo "3. Environment variables ignored by Go binary"
echo "4. Termux-specific DNS resolver issues"
echo ""
echo "### Solutions Attempted:"
echo '```bash'
echo "# All attempted fixes:"
echo "1. export GODEBUG='netdns=go+ipv4'"
echo "2. hosts file modification"
echo "3. socat DNS proxy"
echo "4. iptables redirection (failed - no root)"
echo "5. Manual tunnel creation"
echo "# Successful alternatives:"
echo "- SSH tunneling (serveo.net)"
echo "- Ngrok/LocalTunnel"
echo "- ZeroTier VPN"
echo '```'
echo ""

# 7. Working Services
echo "## 7. Currently Working Services"
echo '```bash'
curl -s http://localhost:8080/ | grep -o '<title>[^<]*</title>' || echo "HTTP Dashboard"
echo ""
echo "Available ports:"
echo "- SSH: 8022"
echo "- HTTP: 8080"
echo "- HTTPS: 8443"
echo "- Uptime Kuma: 3001 (if running)"
echo '```'
echo ""

# 8. Network Configuration
echo "## 8. Network Configuration"
echo '```bash'
ip addr show 2>/dev/null | grep -E "inet|192\.168"
echo ""
echo "DNS config:"
cat /etc/resolv.conf 2>/dev/null || echo "Using default"
echo '```'
echo ""

# 9. Backup Strategy
echo "## 9. Backup Implementation"
if [ -f ~/encrypted_backup.sh ]; then
    echo '```bash'
    head -30 ~/encrypted_backup.sh
    echo '```'
fi
echo ""

# 10. Lessons Learned
echo "## 10. Key Lessons"
echo "1. **Android/Termux DNS limitations**: Go binaries may ignore environment variables"
echo "2. **Alternative tunnels work better**: Ngrok/LocalTunnel are more reliable on mobile"
echo "3. **SSH is reliable**: Reverse SSH tunnels work when Cloudflare doesn't"
echo "4. **Backup everything**: Especially before major changes"
echo "5. **Document as you go**: Commands, errors, and solutions"
echo ""

# 11. Recommended Stack for Android Homelab
echo "## 11. Recommended Stack for Android Homelab"
echo "- **Web Server**: Nginx/PHP"
echo "- **Monitoring**: Uptime Kuma"
echo "- **Tunneling**: Ngrok (free tier) or LocalTunnel"
echo "- **Backup**: Custom encrypted scripts"
echo "- **Management**: Bash scripts with service control"
echo ""

echo "📊 Documentation generated on: $(date)"
