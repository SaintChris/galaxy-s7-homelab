#!/usr/bin/env python3
"""
Restore encrypted Galaxy S7 Homelab backup
"""

import os
import sys
from cryptography.fernet import Fernet

def restore_backup(encrypted_file, output_dir=None):
    """Restore an encrypted backup"""
    if not os.path.exists(encrypted_file):
        print(f"Error: File not found: {encrypted_file}")
        return False
    
    # Determine output directory
    if output_dir is None:
        output_dir = os.path.expanduser("~/restored_backup")
    
    os.makedirs(output_dir, exist_ok=True)
    
    # Load encryption key
    key_file = os.path.expanduser("~/.backup_key")
    if not os.path.exists(key_file):
        print("Error: Backup key not found!")
        print(f"Expected key file: {key_file}")
        return False
    
    with open(key_file, 'rb') as f:
        key = f.read()
    
    # Read encrypted file
    with open(encrypted_file, 'rb') as f:
        encrypted_data = f.read()
    
    # Decrypt
    try:
        fernet = Fernet(key)
        decrypted_data = fernet.decrypt(encrypted_data)
    except Exception as e:
        print(f"Decryption failed: {e}")
        print("Wrong key or corrupted file")
        return False
    
    # Save decrypted backup
    backup_file = os.path.join(output_dir, "restored_backup.tar.gz")
    with open(backup_file, 'wb') as f:
        f.write(decrypted_data)
    
    print(f"✅ Backup decrypted to: {backup_file}")
    print(f"Size: {len(decrypted_data) / 1024 / 1024:.2f} MB")
    print("")
    print("To extract:")
    print(f"  tar -xzf {backup_file} -C {output_dir}/extracted/")
    
    return True

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 restore_backup.py <encrypted_backup.enc> [output_dir]")
        print("")
        print("Available backups:")
        backup_dir = os.path.expanduser("~/backups/encrypted")
        if os.path.exists(backup_dir):
            for f in sorted(os.listdir(backup_dir)):
                if f.endswith('.enc'):
                    print(f"  {os.path.join(backup_dir, f)}")
        sys.exit(1)
    
    encrypted_file = sys.argv[1]
    output_dir = sys.argv[2] if len(sys.argv) > 2 else None
    
    restore_backup(encrypted_file, output_dir)
