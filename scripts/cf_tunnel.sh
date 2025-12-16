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
