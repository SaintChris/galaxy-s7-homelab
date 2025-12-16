#!/bin/bash
echo "=== PHP/Nginx Full Diagnostic ==="
echo ""
echo "1. PHP-FPM Configuration:"
grep "listen =" $PREFIX/etc/php-fpm.d/www.conf
echo ""
echo "2. NGINX Configuration:"
grep -A2 "location ~ \\.php" $PREFIX/etc/nginx/nginx.conf
echo ""
echo "3. Services Status:"
sv status php-fpm
sv status nginx
echo ""
echo "4. Socket File Check:"
SOCKET_PATH="/data/data/com.termux/files/usr/var/run/php-fpm.sock"
if [ -S "$SOCKET_PATH" ]; then
    echo "✅ Socket exists: $SOCKET_PATH"
    ls -la "$SOCKET_PATH"
else
    echo "❌ Socket NOT found: $SOCKET_PATH"
    echo "Checking directory:"
    ls -la /data/data/com.termux/files/usr/var/run/ 2>/dev/null || echo "Directory doesn't exist"
fi
echo ""
echo "5. Network Check:"
netstat -tulpn | grep -E "(9000|8080|php-fpm|nginx)"
echo ""
echo "6. Process Check:"
ps aux | grep -E "(php-fpm|nginx)" | grep -v grep
echo ""
echo "7. Test PHP Execution:"
curl -s http://localhost:8080/test.php | head -3
echo ""
echo "8. Error Logs:"
tail -5 $PREFIX/var/log/nginx/error.log 2>/dev/null | tail -3
echo ""
echo "9. PHP-FPM Logs:"
tail -5 $PREFIX/var/log/php-fpm.log 2>/dev/null
