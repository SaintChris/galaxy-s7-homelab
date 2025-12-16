#!/data/data/com.termux/files/usr/bin/bash
# Galaxy S7 Homelab - Encrypted Backup System

echo "🔐 Starting encrypted backup..."
echo "Timestamp: $(date)"

# Create backup directory
BACKUP_DIR="/data/data/com.termux/files/home/backups/encrypted"
mkdir -p "$BACKUP_DIR"

# Generate backup filename with date
BACKUP_NAME="homelab-$(date +%Y%m%d_%H%M%S)"
TEMP_BACKUP="/tmp/${BACKUP_NAME}.tar.gz"
ENCRYPTED_BACKUP="${BACKUP_DIR}/${BACKUP_NAME}.enc"

# Create backup (excluding large directories)
echo "Creating backup archive..."
tar -czf "$TEMP_BACKUP" \
    --exclude="*/node_modules" \
    --exclude="*/__pycache__" \
    --exclude="*.log" \
    ~/www \
    ~/ssl \
    ~/scripts \
    ~/crypto_utils.py \
    ~/secure_config.py \
    $PREFIX/etc/nginx/nginx.conf \
    $PREFIX/etc/php-fpm.d/www.conf \
    2>/dev/null

# Check if we have encryption available
if python3 -c "import cryptography" 2>/dev/null; then
    echo "Encrypting backup with cryptography library..."
    
    # Create Python script to encrypt the backup
    python3 << 'PYTHON_SCRIPT'
import os
from cryptography.fernet import Fernet

# Load or generate encryption key
key_file = os.path.expanduser("~/.backup_key")
if os.path.exists(key_file):
    with open(key_file, 'rb') as f:
        key = f.read()
else:
    key = Fernet.generate_key()
    with open(key_file, 'wb') as f:
        f.write(key)
    os.chmod(key_file, 0o600)
    print(f"Generated new backup encryption key")

temp_backup = "/tmp/homelab-$(date +%Y%m%d_%H%M%S).tar.gz"
encrypted_backup = "/data/data/com.termux/files/home/backups/encrypted/homelab-$(date +%Y%m%d_%H%M%S).enc"

# Read the backup file
with open(temp_backup, 'rb') as f:
    data = f.read()

# Encrypt it
fernet = Fernet(key)
encrypted = fernet.encrypt(data)

# Save encrypted backup
with open(encrypted_backup, 'wb') as f:
    f.write(encrypted)

print(f"Backup encrypted: {encrypted_backup}")
print(f"Size: {len(encrypted) / 1024 / 1024:.2f} MB")
print(f"Key stored in: {key_file}")
print("⚠️  IMPORTANT: Keep your backup key safe! Without it, backups cannot be restored.")
PYTHON_SCRIPT
    
    # Remove temporary unencrypted backup
    rm -f "$TEMP_BACKUP"
    
    echo "✅ Encrypted backup created: $ENCRYPTED_BACKUP"
else
    echo "⚠️  Cryptography not available, storing unencrypted backup"
    mv "$TEMP_BACKUP" "${BACKUP_DIR}/${BACKUP_NAME}.tar.gz"
    echo "✅ Unencrypted backup created: ${BACKUP_DIR}/${BACKUP_NAME}.tar.gz"
fi

# Clean old backups (keep last 7 days)
echo "Cleaning old backups..."
find "$BACKUP_DIR" -name "*.enc" -mtime +7 -delete
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete

echo "📊 Backup summary:"
du -sh "$BACKUP_DIR"/*
echo ""
echo "🔑 To restore:"
echo "  python3 ~/restore_backup.py $ENCRYPTED_BACKUP"
