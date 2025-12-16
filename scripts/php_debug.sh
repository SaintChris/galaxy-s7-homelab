#!/bin/bash
echo "=== PHP-FPM Debug ==="
echo "1. PHP-FPM Status:"
sv status php-fpm
echo ""
echo "2. PHP-FPM Listen config:"
grep "listen =" $PREFIX/etc/php-fpm.d/www.conf
echo ""
echo "3. NGINX fastcgi_pass:"
grep "fastcgi_pass" $PREFIX/etc/nginx/nginx.conf
echo ""
echo "4. Network connections:"
netstat -tulpn | grep -E "(9000|php-fpm|nginx)"
echo ""
echo "5. Processes:"
ps aux | grep -E "(php-fpm|nginx)" | grep -v grep
echo ""
echo "6. Test PHP file exists:"
ls -la $PREFIX/share/nginx/html/*.php
echo ""
echo "7. Test PHP CLI:"
php --version | head -1
echo ""
echo "8. Test PHP script directly:"
php $PREFIX/share/nginx/html/test.php 2>/dev/null | head -3 || echo "PHP script error"
