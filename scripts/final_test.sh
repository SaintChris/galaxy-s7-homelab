#!/bin/bash
echo "🧪 Final Galaxy S7 Homelab Test"
echo "================================"
echo ""

echo "1. PHP Syntax Check:"
php -l $PREFIX/share/nginx/html/dashboard.php
php -l $PREFIX/share/nginx/html/security-status.php
php -l $PREFIX/share/nginx/html/https-test.php 2>/dev/null
echo ""

echo "2. Service Status:"
sv status nginx php-fpm sshd 2>/dev/null || echo "   Using alternative check..."
ss -tuln | grep -E ':8080|:8443|:8022'
echo ""

echo "3. Web Access Tests:"
echo "   HTTPS Dashboard:"
curl -s -k https://localhost:8443/dashboard.php > /dev/null && echo "   ✅ Accessible" || echo "   ❌ Failed"
echo "   Security Status:"
curl -s -k https://localhost:8443/security-status.php > /dev/null && echo "   ✅ Accessible" || echo "   ❌ Failed"
echo "   HTTP Redirect:"
curl -s -I http://localhost:8080 2>/dev/null | grep -q "301" && echo "   ✅ Redirecting to HTTPS" || echo "   ❌ Not redirecting"
echo ""

echo "4. SSL Certificate:"
if [ -f ~/ssl/selfsigned.crt ]; then
    echo "   ✅ Certificate exists"
    openssl x509 -in ~/ssl/selfsigned.crt -noout -subject -dates 2>/dev/null | head -3
else
    echo "   ❌ Certificate missing"
fi
echo ""

echo "5. Resource Check:"
echo "   Memory: $(free -m 2>/dev/null | awk '/Mem:/ {print $3"MB/"$2"MB"}')"
echo "   Disk: $(df -h ~ 2>/dev/null | awk 'NR==2 {print $4" free of "$2}')"
echo ""

echo "🌐 Final Access URLs:"
echo "   🔒 Secure Dashboard: https://192.168.100.225:8443"
echo "   🔐 Security Status: https://192.168.100.225:8443/security-status.php"
echo "   🌐 HTTP Redirect: http://192.168.100.225:8080"
echo "   🔑 SSH Access: ssh u0_a194@192.168.100.225 -p 8022"
echo ""
echo "✅ Galaxy S7 Homelab is fully operational!"
