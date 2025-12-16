#!/bin/bash
echo "🔐 Testing HTTPS Setup..."
echo ""

echo "1. Checking SSL certificate:"
if [ -f ~/ssl/selfsigned.crt ]; then
    echo "✅ Certificate exists"
    echo "   Location: ~/ssl/selfsigned.crt"
else
    echo "❌ Certificate missing"
fi
echo ""

echo "2. Checking NGINX config:"
nginx -t 2>&1
echo ""

echo "3. Checking listening ports:"
echo "Port 8080 (HTTP):"
ss -tuln | grep ':8080' || echo "   Not listening"
echo ""
echo "Port 8443 (HTTPS):"
ss -tuln | grep ':8443' || echo "   Not listening"
echo ""

echo "4. Testing HTTP redirect:"
echo "   Testing: curl -I http://localhost:8080"
curl -s -I http://localhost:8080 2>/dev/null | grep -i "location\|http" | head -2
echo ""

echo "5. Testing HTTPS access:"
echo "   Testing: curl -k https://localhost:8443"
if curl -s -k https://localhost:8443 > /dev/null 2>&1; then
    echo "✅ HTTPS server responding"
    echo ""
    echo "🌐 Access URLs:"
    echo "   HTTPS: https://192.168.100.225:8443"
    echo "   HTTP:  http://192.168.100.225:8080 (will redirect to HTTPS)"
else
    echo "❌ HTTPS not responding"
fi
echo ""

echo "6. Testing PHP via HTTPS:"
curl -s -k "https://localhost:8443/https-test.php" | grep -i "secure\|insecure" | head -1
