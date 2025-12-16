#!/bin/bash
echo "🔍 Testing PHP Functions Availability in Termux..."
echo ""

# Test sys_getloadavg
php -r "if (function_exists('sys_getloadavg')) { \$load = sys_getloadavg(); echo '✅ sys_getloadavg() available: ' . (\$load[0] ?? 'N/A') . '\n'; } else { echo '❌ sys_getloadavg() not available\n'; }"

# Test other common functions
php -r "
echo 'Testing system functions:\n';
\$functions = [
    'shell_exec', 'exec', 'system', 'passthru',
    'file_get_contents', 'file_exists', 'is_readable',
    'fsockopen', 'preg_match', 'json_encode'
];

foreach (\$functions as \$fn) {
    if (function_exists(\$fn)) {
        echo '  ✅ ' . \$fn . '\n';
    } else {
        echo '  ❌ ' . \$fn . '\n';
    }
}
"

# Test /proc filesystem access
echo ""
echo "Testing /proc filesystem:"
if [ -f /proc/loadavg ]; then
    echo "✅ /proc/loadavg exists"
    cat /proc/loadavg
else
    echo "❌ /proc/loadavg not accessible"
fi

if [ -f /proc/meminfo ]; then
    echo "✅ /proc/meminfo exists"
    grep -E "MemTotal|MemFree|MemAvailable" /proc/meminfo | head -3
else
    echo "❌ /proc/meminfo not accessible"
fi

# Test uptime command
echo ""
echo "Testing uptime command:"
uptime 2>/dev/null || echo "Uptime command not available"

# Test alternative load average methods
echo ""
echo "Alternative load average methods:"
echo "1. From /proc: $(cat /proc/loadavg 2>/dev/null | awk '{print $1}' || echo 'N/A')"
echo "2. From uptime: $(uptime 2>/dev/null | grep -o 'load average:.*' || echo 'N/A')"
echo "3. From top: $(top -bn1 2>/dev/null | grep 'load average' || echo 'N/A')"
