#!/data/data/com.termux/files/usr/bin/bash
while true; do
    echo "Starting SSH tunnel to serveo.net..."
    ssh -o ServerAliveInterval=30 \
        -o ServerAliveCountMax=3 \
        -o ExitOnForwardFailure=yes \
        -R galaxy-s7-homelab:80:localhost:8080 \
        serveo.net
    
    echo "Tunnel disconnected. Reconnecting in 5 seconds..."
    sleep 5
done
