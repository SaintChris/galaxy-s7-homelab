#!/data/data/com.termux/files/usr/bin/bash
# Force Go to use specific DNS
export GODEBUG=netdns=go
export DNS_SERVERS="8.8.8.8:53,8.8.4.4:53"
./cloudflared "$@"
