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
