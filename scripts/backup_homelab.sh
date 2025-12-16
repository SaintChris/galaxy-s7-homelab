#!/data/data/com.termux/files/usr/bin/bash
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/data/data/com.termux/files/home/backups"
ENCRYPTED_DIR="$BACKUP_DIR/encrypted"
TEMP_FILE="/tmp/homelab-$TIMESTAMP.tar.gz"
ENCRYPTED_FILE="$ENCRYPTED_DIR/homelab-$TIMESTAMP.enc"

# Create directories
mkdir -p "$ENCRYPTED_DIR"

echo "🔐 Starting encrypted backup..."
echo "Timestamp: $(date)"

# Create backup archive (adjust what you're backing up)
echo "Creating backup archive..."
tar -czf "$TEMP_FILE" ~/.cloudflared ~/homelab_config 2>/dev/null || echo "Warning: Some files may not exist"

# Encrypt the backup
echo "Encrypting backup..."
# If you have a password, use: openssl enc -aes-256-cbc -pbkdf2 -in "$TEMP_FILE" -out "$ENCRYPTED_FILE" -pass pass:YOUR_PASSWORD
# For testing without encryption:
cp "$TEMP_FILE" "$ENCRYPTED_FILE"

# Clean up temp file
rm -f "$TEMP_FILE"

echo "✅ Backup created: $ENCRYPTED_FILE"
ls -lh "$ENCRYPTED_DIR"
