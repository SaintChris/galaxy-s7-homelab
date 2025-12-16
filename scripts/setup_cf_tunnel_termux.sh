#!/data/data/com.termux/files/usr/bin/bash
echo "📱 Cloudflare Tunnel Setup for Termux (Android)"
echo "================================================"
echo ""

echo "📝 Prerequisites:"
echo "   1. Cloudflare account (free)"
echo "   2. Domain name (or use Cloudflare's free subdomain)"
echo "   3. A computer/laptop for browser login"
echo ""

# Step 1: Download the correct binary
echo "1. Downloading cloudflared for Android ARM64..."
cd ~
if [ ! -f cloudflared ]; then
    wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm -O cloudflared
    # Try alternative if that fails
    if [ $? -ne 0 ]; then
        echo "   Trying alternative download..."
        wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -O cloudflared
    fi
    
    if [ -f cloudflared ]; then
        chmod +x cloudflared
        mv cloudflared $PREFIX/bin/
        echo "   ✅ cloudflared installed"
    else
        echo "   ❌ Download failed. Try manual download:"
        echo "   wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm"
        exit 1
    fi
else
    echo "   ✅ cloudflared already installed"
fi

# Step 2: Get login URL
echo ""
echo "2. Getting authentication URL..."
echo "   Run this command:"
echo "   cloudflared tunnel login 2>&1 | grep -o 'https://[^ ]*' | head -1"
echo ""
echo "   Then:"
echo "   1. Copy the URL"
echo "   2. Open it on a computer/laptop browser"
echo "   3. Login to Cloudflare"
echo "   4. Authorize the tunnel"
echo "   5. The cert.pem will download automatically"
echo ""

# Step 3: Manual instructions for cert transfer
echo "3. Transfer certificate to Galaxy S7:"
echo "   Method A: Use Termux file sharing:"
echo "     1. On computer, move cert.pem to Downloads"
echo "     2. On Galaxy S7, run: termux-setup-storage"
echo "     3. Then: cp ~/storage/downloads/cert.pem ~/.cloudflared/"
echo ""
echo "   Method B: Copy-paste contents:"
echo "     1. On computer: cat cert.pem"
echo "     2. Copy the entire contents"
echo "     3. On Galaxy S7: nano ~/.cloudflared/cert.pem"
echo "     4. Paste and save (Ctrl+X, Y, Enter)"
echo ""

# Step 4: Create tunnel
echo "4. Creating tunnel..."
echo "   After certificate is in ~/.cloudflared/cert.pem"
echo "   Run: cloudflared tunnel create galaxy-s7"
echo "   Save the Tunnel ID shown!"
echo ""

# Step 5: Create config
mkdir -p ~/.cloudflared

cat > ~/.cloudflared/config-example.yml << 'CONFIG'
# Cloudflare Tunnel Config for Galaxy S7
# Replace YOUR_TUNNEL_ID and YOUR_DOMAIN

tunnel: YOUR_TUNNEL_ID
credentials-file: /data/data/com.termux/files/home/.cloudflared/YOUR_TUNNEL_ID.json

# No browser, use simple ingress
ingress:
  # Route web traffic
  - hostname: galaxy.your-domain.com
    service: https://localhost:8443
    originRequest:
      noTLSVerify: true  # For self-signed certs
  
  # Catch-all rule
  - service: http_status:404
CONFIG

echo "5. Config template created: ~/.cloudflared/config-example.yml"
echo "   Edit with: nano ~/.cloudflared/config.yml"
echo ""

# Step 6: Create easy management script
cat > ~/cf_tunnel.sh << 'TUNNEL_SCRIPT'
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
            echo "🌐 Routing $2 to tunnel..."
            cloudflared tunnel route dns galaxy-s7 "$2"
        fi
        ;;
    url)
        echo "🔗 Your tunnel URLs:"
        echo "   Check Cloudflare Dashboard: https://dash.cloudflare.com/"
        echo "   Or run: cloudflared tunnel route ip show"
        ;;
    *)
        echo "Usage: $0 {start|stop|status|logs|route|url}"
        echo ""
        echo "Commands:"
        echo "  start   - Start the tunnel"
        echo "  stop    - Stop the tunnel"
        echo "  status  - Check tunnel status"
        echo "  logs    - Show tunnel logs"
        echo "  route   - Route domain to tunnel"
        echo "  url     - Show tunnel URL info"
        ;;
esac
TUNNEL_SCRIPT

chmod +x ~/cf_tunnel.sh
echo "6. Management script created: ~/cf_tunnel.sh"
echo ""

# Step 7: Integration with homelab
cat > ~/start_public_homelab.sh << 'PUBLIC_SCRIPT'
#!/data/data/com.termux/files/usr/bin/bash
echo "🌍 Starting Public Galaxy S7 Homelab"
echo ""

# Start local services
echo "1. Starting local services..."
./manage_server.sh start
sleep 3

# Start Cloudflare Tunnel
echo "2. Starting Cloudflare Tunnel..."
./cf_tunnel.sh start
sleep 5

echo ""
echo "✅ Public homelab started!"
echo ""
echo "🔗 Access URLs:"
echo "   Local: https://192.168.100.225:8443"
echo "   Public: Configure in Cloudflare Dashboard"
echo ""
echo "📊 Status:"
./manage_server.sh status
echo ""
./cf_tunnel.sh status
PUBLIC_SCRIPT

chmod +x ~/start_public_homelab.sh

echo "7. Public startup script: ~/start_public_homelab.sh"
echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Get login URL: cloudflared tunnel login 2>&1 | grep -o 'https://[^ ]*'"
echo "   2. Authorize on computer browser"
echo "   3. Transfer cert.pem to ~/.cloudflared/"
echo "   4. Create tunnel: cloudflared tunnel create galaxy-s7"
echo "   5. Edit config: nano ~/.cloudflared/config.yml"
echo "   6. Start: ./start_public_homelab.sh"
echo ""
echo "⚠️  Note: Cloudflare may limit free tunnels to 5 connections"
