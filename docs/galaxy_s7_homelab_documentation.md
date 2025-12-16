# Galaxy S7 Homelab - Full Documentation Generator
==================================================

📋 Gathering system information...

## 1. System Information
```bash
Linux localhost 3.18.71-15151201 #1 SMP PREEMPT Tue Feb 11 14:02:22 KST 2020 aarch64 Android

Termux version:
termux-am-socket/stable,now 1.5.0-1 aarch64 [installed]
termux-am/stable,now 0.8.0-2 all [installed]
termux-auth/stable,now 1.5.0-1 aarch64 [installed,automatic]
termux-core/stable,now 0.4.0-1 aarch64 [installed]
termux-exec/stable,now 1:2.4.0-1 aarch64 [installed]
termux-keyring/stable,now 3.13 all [installed]
termux-licenses/stable,now 2.1 all [installed]
termux-services/stable,now 0.13-1 all [installed]
termux-tools/stable,now 1.46.0+really1.45.0-1 aarch64 [installed]

Free space:
Filesystem      Size  Used Avail Use% Mounted on
/dev/block/dm-1  23G  8.3G   15G  37% /data
```

## 2. Installed Packages
```bash
Listing...
apt/stable,now 2.8.1-2 aarch64 [installed]
attr/stable,now 2.5.2-1 aarch64 [installed,automatic]
bash/stable,now 5.3.8 aarch64 [installed]
binutils-bin/stable,now 2.45.1 aarch64 [installed,automatic]
binutils-libs/stable,now 2.45.1 aarch64 [installed,automatic]
binutils/stable,now 2.45.1 aarch64 [installed]
bzip2/stable,now 1.0.8-8 aarch64 [installed]
c-ares/stable,now 1.34.6 aarch64 [installed,automatic]
ca-certificates/stable,now 1:2025.12.02 all [installed]
clang/stable,now 21.1.7 aarch64 [installed]
command-not-found/stable,now 3.2-7 aarch64 [installed]
coreutils/stable,now 9.9 aarch64 [installed]
curl/stable,now 8.17.0 aarch64 [installed]
dash/stable,now 0.5.12-1 aarch64 [installed]
debianutils/stable,now 5.23.2-1 aarch64 [installed]
dialog/stable,now 1.3-20240307-1 aarch64 [installed]
diffutils/stable,now 3.12-2 aarch64 [installed]
dos2unix/stable,now 7.5.2-1 aarch64 [installed]
dpkg/stable,now 1.22.6-5 aarch64 [installed]
ed/stable,now 1.22.3 aarch64 [installed]
findutils/stable,now 4.10.0-1 aarch64 [installed]
gawk/stable,now 5.3.1-2 aarch64 [installed]
gdbm/stable,now 1.26-1 aarch64 [installed,automatic]
git/stable,now 2.52.0 aarch64 [installed]
glib/stable,now 2.86.3 aarch64 [installed,automatic]
gpgv/stable,now 2.5.11 aarch64 [installed]
grep/stable,now 3.12-2 aarch64 [installed]
gzip/stable,now 1.14-1 aarch64 [installed]
htop/stable,now 3.4.1-1 aarch64 [installed]
...
```

## 3. Project Structure
```bash
/data/data/com.termux/files/home/uptime-kuma/.eslintrc.js
/data/data/com.termux/files/home/uptime-kuma/ecosystem.config.js
/data/data/com.termux/files/home/uptime-kuma/package.json
/data/data/com.termux/files/home/uptime-kuma/tsconfig-backend.json
/data/data/com.termux/files/home/uptime-kuma/tsconfig.json
/data/data/com.termux/files/home/package-lock.json
/data/data/com.termux/files/home/check_server.sh
/data/data/com.termux/files/home/php_debug.sh
/data/data/com.termux/files/home/verify_php.sh
/data/data/com.termux/files/home/diagnose_php.sh
/data/data/com.termux/files/home/crypto_utils.py
/data/data/com.termux/files/home/secure_config.py
/data/data/com.termux/files/home/encrypted_backup.sh
/data/data/com.termux/files/home/restore_backup.py
/data/data/com.termux/files/home/test_crypto.sh
/data/data/com.termux/files/home/deployment_check.sh
/data/data/com.termux/files/home/manage_server.sh
/data/data/com.termux/files/home/test_https_setup.sh
/data/data/com.termux/files/home/verify_https.sh
/data/data/com.termux/files/home/check_php_errors.sh
/data/data/com.termux/files/home/test_php_functions.sh
/data/data/com.termux/files/home/final_test.sh
/data/data/com.termux/files/home/setup_cf_tunnel_termux.sh
/data/data/com.termux/files/home/cf_tunnel.sh
/data/data/com.termux/files/home/start_public_homelab.sh
/data/data/com.termux/files/home/setup_cloudflare_complete.sh
/data/data/com.termux/files/home/cf_simple_setup.sh
/data/data/com.termux/files/home/verify_cert.sh
/data/data/com.termux/files/home/cf_with_dns.sh
/data/data/com.termux/files/home/backup_homelab.sh
```

## 4. Key Scripts
### manage_server.sh
```bash
#!/data/data/com.termux/files/usr/bin/bash
case "$1" in
    start)
        echo "Starting Galaxy S7 Homelab..."
        sv up sshd && sv up nginx && sv up php-fpm
        echo "✓ Services started"
        echo "  SSH: ssh $(whoami)@$(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | head -1):8022"
        echo "  HTTP: http://$(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | head -1):8080"
        echo "  HTTPS: https://$(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | head -1):8443"
        ;;
    stop) 
        sv down nginx php-fpm sshd
        echo "Services stopped"
        ;;
    restart)
        $0 stop
        sleep 2
        $0 start
        ;;
    status)
        echo "=== Galaxy S7 Homelab Status ==="
        echo "SSH: $(sv status sshd 2>/dev/null | grep -o 'run' || echo 'down')"
        echo "NGINX: $(sv status nginx 2>/dev/null | grep -o 'run' || echo 'down')"
        echo "PHP-FPM: $(sv status php-fpm 2>/dev/null | grep -o 'run' || echo 'down')"
        echo "IP: $(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | head -1)"
        echo "Memory: $(free -m | awk '/Mem:/ {printf "%.1f%%", $3/$2*100}') used"
        ;;
    backup)
        BACKUP="homelab-$(date +%Y%m%d_%H%M%S).tar.gz"
        tar -czf ~/$BACKUP ~/www ~/ssl ~/scripts ~/*.py ~/*.sh 2>/dev/null
        echo "Backup created: ~/$BACKUP"
        ls -lh ~/$BACKUP
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|backup}"
        ;;
esac
```

### encrypted_backup.sh
```bash
#!/data/data/com.termux/files/usr/bin/bash
# Galaxy S7 Homelab - Encrypted Backup System

echo "🔐 Starting encrypted backup..."
echo "Timestamp: $(date)"

# Create backup directory
BACKUP_DIR="/data/data/com.termux/files/home/backups/encrypted"
mkdir -p "$BACKUP_DIR"

# Generate backup filename with date
BACKUP_NAME="homelab-$(date +%Y%m%d_%H%M%S)"
TEMP_BACKUP="/tmp/${BACKUP_NAME}.tar.gz"
ENCRYPTED_BACKUP="${BACKUP_DIR}/${BACKUP_NAME}.enc"

# Create backup (excluding large directories)
echo "Creating backup archive..."
tar -czf "$TEMP_BACKUP" \
    --exclude="*/node_modules" \
    --exclude="*/__pycache__" \
    --exclude="*.log" \
    ~/www \
    ~/ssl \
    ~/scripts \
    ~/crypto_utils.py \
    ~/secure_config.py \
    $PREFIX/etc/nginx/nginx.conf \
    $PREFIX/etc/php-fpm.d/www.conf \
    2>/dev/null

# Check if we have encryption available
if python3 -c "import cryptography" 2>/dev/null; then
    echo "Encrypting backup with cryptography library..."
    
    # Create Python script to encrypt the backup
    python3 << 'PYTHON_SCRIPT'
import os
from cryptography.fernet import Fernet

# Load or generate encryption key
key_file = os.path.expanduser("~/.backup_key")
if os.path.exists(key_file):
    with open(key_file, 'rb') as f:
        key = f.read()
else:
    key = Fernet.generate_key()
    with open(key_file, 'wb') as f:
        f.write(key)
    os.chmod(key_file, 0o600)
    print(f"Generated new backup encryption key")
```

### cf_tunnel.sh
```bash
#!/data/data/com.termux/files/usr/bin/bash

CONFIG="$HOME/.cloudflared/config.yml"

if [ ! -f "$CONFIG" ]; then
    echo "❌ Config file not found: $CONFIG"
    echo "   Copy from example: cp ~/.cloudflared/config-example.yml ~/.cloudflared/config.yml"
    echo "   Then edit with your tunnel ID and domain"
    exit 1
fi

case "$1" in
    start)
        echo "🚀 Starting Cloudflare Tunnel..."
        # Run in background, log to file
        cloudflared tunnel --config "$CONFIG" run galaxy-s7 > ~/.cloudflared/tunnel.log 2>&1 &
        echo $! > ~/.cloudflared/tunnel.pid
        echo "✅ Tunnel started (PID: $(cat ~/.cloudflared/tunnel.pid))"
        echo "📝 Logs: ~/.cloudflared/tunnel.log"
        sleep 2
        echo ""
        echo "🔍 Checking status..."
        cloudflared tunnel info galaxy-s7 2>/dev/null || echo "   Still starting..."
        ;;
    stop)
        if [ -f ~/.cloudflared/tunnel.pid ]; then
            PID=$(cat ~/.cloudflared/tunnel.pid)
            echo "🛑 Stopping Cloudflare Tunnel (PID: $PID)..."
            kill $PID 2>/dev/null
            rm -f ~/.cloudflared/tunnel.pid
            echo "✅ Tunnel stopped"
        else
            echo "⚠️  No tunnel PID file found"
            pkill -f "cloudflared tunnel" && echo "✅ Stopped running tunnels" || echo "✅ No tunnels running"
        fi
        ;;
    status)
        echo "📊 Cloudflare Tunnel Status:"
        cloudflared tunnel info galaxy-s7 2>/dev/null || echo "   Not running or not configured"
        ps aux | grep "cloudflared tunnel" | grep -v grep || echo "   No tunnel process found"
        ;;
    logs)
        echo "📋 Recent logs:"
        tail -20 ~/.cloudflared/tunnel.log 2>/dev/null || echo "   No log file found"
        ;;
    route)
        if [ -z "$2" ]; then
            echo "Usage: $0 route <domain>"
            echo "Example: $0 route galaxy.your-domain.com"
        else
```

### setup_cloudflare_complete.sh
```bash
#!/data/data/com.termux/files/usr/bin/bash
echo "🔷 Cloudflare Tunnel Setup for Galaxy S7"
echo "========================================="

# Download cloudflared
echo "1. Downloading cloudflared..."
cd ~
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm -O cloudflared
chmod +x cloudflared

# Create config directory
mkdir -p ~/.cloudflared

# Create example config
cat > ~/.cloudflared/config-example.yml << 'CONFIG'
tunnel: YOUR_TUNNEL_ID
credentials-file: /data/data/com.termux/files/home/.cloudflared/YOUR_TUNNEL_ID.json

ingress:
  - hostname: galaxy-s7.your-domain.com
    service: https://localhost:8443
    originRequest:
      noTLSVerify: true
  
  - service: http_status:404
CONFIG

echo "✅ Setup script created"
echo ""
echo "📋 Next: Get your Cloudflare API Token and Account ID"
echo "   Then run: ./cf_simple_setup.sh YOUR_TOKEN YOUR_ACCOUNT_ID"
```

## 5. Running Services
```bash
u0_a194   3298  0.0  0.0   9124  2236 ?        S<    1970   0:05 runsv ssh-agent
u0_a194   3299  0.0  0.0   9124  2224 ?        S<    1970   0:05 runsv sshd
u0_a194   3300  0.0  0.0   9124  2124 ?        S<    1970   0:05 runsv nginx
u0_a194   3301  0.0  0.0   9132  2084 ?        S<    1970   0:04 svlogd -tt /data/data/com.termux/files/usr/var/log/sv/nginx
u0_a194   3302  0.0  0.0   9132  2392 ?        S<    1970   0:04 svlogd -tt /data/data/com.termux/files/usr/var/log/sv/ssh-agent
u0_a194   3303  0.0  0.0   9132  2284 ?        S<    1970   0:04 svlogd -tt /data/data/com.termux/files/usr/var/log/sv/sshd
u0_a194   8197  0.0  0.1  17836  6916 ?        S<    1970   0:00 nginx: master process nginx -p /data/data/com.termux/files/home/.nginx -g daemon off; -c /data/data/com.termux/files/usr/etc/nginx/nginx.conf
u0_a194   8199  0.1  0.1  17836  5612 ?        S<    1970   0:17 nginx: worker process
u0_a194   8491  0.0  0.1  16128  4460 pts/0    S<    1970   0:06 sshd -D -o ListenAddress=0.0.0.0
u0_a194  14253  0.0  0.0  16804  2996 ?        S<s   1970   0:01 /data/data/com.termux/files/usr/libexec/sshd-session -D -o ListenAddress=0.0.0.0 -R
u0_a194  14255  0.0  0.0  16804  1392 ?        S<    1970   0:11 /data/data/com.termux/files/usr/libexec/sshd-session -D -o ListenAddress=0.0.0.0 -R
u0_a194  14930  0.0  0.1  16804  6148 ?        S<s   1970   0:00 /data/data/com.termux/files/usr/libexec/sshd-session -D -o ListenAddress=0.0.0.0 -R
u0_a194  14936  1.0  0.0  16804  3732 ?        S<    1970   0:16 /data/data/com.termux/files/usr/libexec/sshd-session -D -o ListenAddress=0.0.0.0 -R
u0_a194  15094  0.0  0.0  16128  2640 ?        S<    1970   0:00 sshd -D -e
u0_a194  19270  0.0  0.2  16804  7992 ?        S<s   1970   0:00 /data/data/com.termux/files/usr/libexec/sshd-session -D -o ListenAddress=0.0.0.0 -R
u0_a194  19273  1.6  0.1  16804  5480 ?        S<    1970   0:08 /data/data/com.termux/files/usr/libexec/sshd-session -D -o ListenAddress=0.0.0.0 -R
u0_a194  21280  0.0  0.0   9124  2256 ?        S<    1970   0:01 runsv php-fpm
u0_a194  21281  0.0  0.0   9132  2280 ?        S<    1970   0:00 svlogd -tt /data/data/com.termux/files/usr/var/log/sv/php-fpm
u0_a194  27777  0.0  0.1  91128  6800 ?        S<s   1970   0:02 php-fpm: master process (/data/data/com.termux/files/usr/etc/php-fpm.conf)
u0_a194  27780  0.0  0.1  91128  4428 ?        S<    1970   0:06 php-fpm: pool www
u0_a194  27781  0.0  0.1  91128  4628 ?        S<    1970   0:03 php-fpm: pool www

tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:8022            0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:8443            0.0.0.0:*               LISTEN     
tcp6       0      0 :::8022                 :::*                    LISTEN     
```

## 6. Cloudflare Tunnel Issues & Solutions
### Problems Encountered:
1. DNS resolution failure: `[::1]:53: connection refused`
2. API authentication errors due to DNS
3. Environment variables ignored by Go binary
4. Termux-specific DNS resolver issues

### Solutions Attempted:
```bash
# All attempted fixes:
1. export GODEBUG='netdns=go+ipv4'
2. hosts file modification
3. socat DNS proxy
4. iptables redirection (failed - no root)
5. Manual tunnel creation
# Successful alternatives:
- SSH tunneling (serveo.net)
- Ngrok/LocalTunnel
- ZeroTier VPN
```

## 7. Currently Working Services
```bash
<title>301 Moved Permanently</title>

Available ports:
- SSH: 8022
- HTTP: 8080
- HTTPS: 8443
- Uptime Kuma: 3001 (if running)
```

## 8. Network Configuration
```bash
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host 
    inet6 fe80::3c2d:36ff:fee6:49c7/64 scope link 
    inet6 fe80::ac5f:3eff:feb9:249e/64 scope link 
    inet 192.168.100.225/24 brd 192.168.100.255 scope global wlan0
    inet6 2605:a200:3001:2cc1:ec85:6ff1:713e:7fd2/64 scope global temporary dynamic 
    inet6 2605:a200:3001:2cc1:ae5f:3eff:feb9:249e/64 scope global dynamic mngtmpaddr 
    inet6 fe80::ae5f:3eff:feb9:249e/64 scope link 

DNS config:
Using default
```

## 9. Backup Implementation
```bash
#!/data/data/com.termux/files/usr/bin/bash
# Galaxy S7 Homelab - Encrypted Backup System

echo "🔐 Starting encrypted backup..."
echo "Timestamp: $(date)"

# Create backup directory
BACKUP_DIR="/data/data/com.termux/files/home/backups/encrypted"
mkdir -p "$BACKUP_DIR"

# Generate backup filename with date
BACKUP_NAME="homelab-$(date +%Y%m%d_%H%M%S)"
TEMP_BACKUP="/tmp/${BACKUP_NAME}.tar.gz"
ENCRYPTED_BACKUP="${BACKUP_DIR}/${BACKUP_NAME}.enc"

# Create backup (excluding large directories)
echo "Creating backup archive..."
tar -czf "$TEMP_BACKUP" \
    --exclude="*/node_modules" \
    --exclude="*/__pycache__" \
    --exclude="*.log" \
    ~/www \
    ~/ssl \
    ~/scripts \
    ~/crypto_utils.py \
    ~/secure_config.py \
    $PREFIX/etc/nginx/nginx.conf \
    $PREFIX/etc/php-fpm.d/www.conf \
    2>/dev/null

```

## 10. Key Lessons
1. **Android/Termux DNS limitations**: Go binaries may ignore environment variables
2. **Alternative tunnels work better**: Ngrok/LocalTunnel are more reliable on mobile
3. **SSH is reliable**: Reverse SSH tunnels work when Cloudflare doesn't
4. **Backup everything**: Especially before major changes
5. **Document as you go**: Commands, errors, and solutions

## 11. Recommended Stack for Android Homelab
- **Web Server**: Nginx/PHP
- **Monitoring**: Uptime Kuma
- **Tunneling**: Ngrok (free tier) or LocalTunnel
- **Backup**: Custom encrypted scripts
- **Management**: Bash scripts with service control

📊 Documentation generated on: Fri Dec 12 19:12:12 EST 2025
