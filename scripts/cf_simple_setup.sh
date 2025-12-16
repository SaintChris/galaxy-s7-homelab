#!/data/data/com.termux/files/usr/bin/bash
echo "🌐 Cloudflare Tunnel Simple Setup"

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <API_TOKEN> <ACCOUNT_ID>"
    echo ""
    echo "Example: $0 abc123def456 9876543210abcdef"
    echo ""
    echo "Get these from:"
    echo "  API Token: https://dash.cloudflare.com/profile/api-tokens"
    echo "  Account ID: Look in dashboard URL after /"
    exit 1
fi

API_TOKEN="$1"
ACCOUNT_ID="$2"

echo "1. Creating tunnel with API token..."
export CLOUDFLARE_API_TOKEN="$API_TOKEN"

# Try to create tunnel
./cloudflared tunnel create --token "$API_TOKEN" galaxy-s7-homelab 2>&1 | tee /tmp/tunnel_output.txt

echo ""
echo "2. Check output above for Tunnel ID"
echo "   It looks like: Created tunnel abc123def456"
echo ""
echo "3. If successful, create config manually:"
echo "   nano ~/.cloudflared/config.yml"
echo ""
echo "4. Then start tunnel:"
echo "   ./cloudflared tunnel --config ~/.cloudflared/config.yml run galaxy-s7-homelab"
