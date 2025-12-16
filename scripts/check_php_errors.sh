#!/bin/bash
echo "🔍 Checking PHP files for errors..."
echo ""

# Check each PHP file
for file in $PREFIX/share/nginx/html/*.php; do
    if [ -f "$file" ]; then
        echo "Checking: $(basename "$file")"
        php -l "$file" 2>&1
        echo ""
    fi
done

# Also check your scripts
for file in ~/*.php 2>/dev/null; do
    if [ -f "$file" ]; then
        echo "Checking: ~/$(basename "$file")"
        php -l "$file" 2>&1
        echo ""
    fi
done

echo "✅ PHP error check complete"
echo ""
echo "To enable error display temporarily for debugging:"
echo "  php -d display_errors=1 -f yourfile.php"
echo ""
echo "To check PHP version:"
php --version | head -1
