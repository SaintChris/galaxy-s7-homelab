#!/bin/bash
echo "=== PHP/Nginx Verification ==="
echo ""
echo "1. Connection methods:"
echo "PHP-FPM listen: $(grep 'listen =' $PREFIX/etc/php-fpm.d/www.conf | head -1)"
echo "NGINX fastcgi_pass: $(grep 'fastcgi_pass' $PREFIX/etc/nginx/nginx.conf)"
echo ""
echo "2. Socket/TCP status:"
if grep -q "unix:" $PREFIX/etc/nginx/nginx.conf; then
    SOCKET=$(grep "fastcgi_pass" $PREFIX/etc/nginx/nginx.conf | cut -d' ' -f2 | tr -d ';')
    echo "Using Unix socket: $SOCKET"
    ls -la $SOCKET 2>/dev/null || echo "Socket not found"
else
    echo "Using TCP port 9000"
    netstat -tulpn | grep 9000 || echo "Port 9000 not listening"
fi
echo ""
echo "3. Services:"
sv status php-fpm
sv status nginx
echo ""
echo "4. Test PHP:"
curl -s http://localhost:8080/test.php | head -5
echo ""
echo "5. Last error logs:"
tail -3 $PREFIX/var/log/nginx/error.log 2>/dev/null | grep -v "favicon.ico" || echo "No recent errors"
