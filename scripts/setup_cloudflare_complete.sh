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
