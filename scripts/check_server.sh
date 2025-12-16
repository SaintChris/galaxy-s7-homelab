#!/bin/bash
echo "=== Galaxy S7 Server Status ==="
echo "Time: $(date)"
echo "Uptime: $(uptime -p)"
echo ""
echo "=== Services ==="
sv status nginx
sv status sshd 2>/dev/null || echo "sshd: Not configured"
echo ""
echo "=== Resources ==="
free -h | grep Mem
echo ""
echo "=== Web Server ==="
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:8080
echo ""
echo "=== Connections ==="
netstat -tulpn | grep -E "(nginx|sshd)" | head -10
