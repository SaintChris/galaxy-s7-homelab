#!/data/data/com.termux/files/usr/bin/bash
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/data/data/com.termux/files/home/backups"
ENCRYPTED_DIR="$BACKUP_DIR/encrypted"
TEMP_FILE="$HOME/tmp/homelab-$TIMESTAMP.tar.gz"
ENCRYPTED_FILE="$ENCRYPTED_DIR/homelab-$TIMESTAMP.enc"

# Create directories
mkdir -p "$ENCRYPTED_DIR"
mkdir -p "$HOME/tmp"

echo "🔐 Starting encrypted backup..."
echo "Timestamp: $(date)"

# Create backup archive - BACKUP YOUR IMPORTANT FILES
echo "Creating backup archive..."
tar -czf "$TEMP_FILE" \
  ~/.cloudflared \
  ~/www \
  ~/manage_server.sh \
  ~/*.sh 2>/dev/null

# Simple encryption (or just copy for now)
echo "Encrypting backup..."
if command -v openssl &> /dev/null; then
    openssl enc -aes-256-cbc -salt -in "$TEMP_FILE" -out "$ENCRYPTED_FILE" -pass pass:your_password_here
else
    cp "$TEMP_FILE" "$ENCRYPTED_FILE"
    echo "Note: openssl not found, backup not encrypted"
fi

# Clean up
rm -f "$TEMP_FILE"

echo "✅ Backup created: $(ls -lh "$ENCRYPTED_FILE")"
echo "📁 All backups:"
ls -lh "$ENCRYPTED_DIR" 2>/dev/null || echo "No backups yet"
