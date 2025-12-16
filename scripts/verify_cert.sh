#!/bin/bash
echo "🔍 Verifying Cloudflare Certificate"
echo ""

CERT_FILE="$HOME/.cloudflared/cert.pem"

if [ ! -f "$CERT_FILE" ]; then
    echo "❌ cert.pem not found"
    exit 1
fi

SIZE=$(stat -c%s "$CERT_FILE")
if [ "$SIZE" -eq 0 ]; then
    echo "❌ cert.pem is EMPTY (0 bytes)"
    echo ""
    echo "Fix by:"
    echo "1. On Rocky Linux VM, run: cat ~/Downloads/cert.pem"
    echo "2. Copy ALL text (-----BEGIN to -----END)"
    echo "3. On Galaxy S7: nano ~/.cloudflared/cert.pem"
    echo "4. Paste and save"
    exit 1
fi

echo "✅ cert.pem exists: $SIZE bytes"
echo "First line: $(head -1 "$CERT_FILE")"
echo "Last line: $(tail -1 "$CERT_FILE")"
echo ""
echo "✅ Certificate looks good!"
