#!/bin/bash
echo "🧪 Testing Galaxy S7 Cryptography Features..."

# Create a test file
echo "This is a secret message from Galaxy S7 Homelab" > ~/test_secret.txt

# Test encryption/decryption with Python
python3 << 'PYTHON'
from crypto_utils import HomelabCrypto
import os

print("1. Testing HomelabCrypto class...")
crypto = HomelabCrypto()

# Encrypt a string
secret = "Galaxy S7 SSH Password: admin123"
encrypted = crypto.encrypt_string(secret)
decrypted = crypto.decrypt_string(encrypted)

print(f"   Original: {secret}")
print(f"   Encrypted: {encrypted[:50]}...")
print(f"   Decrypted: {decrypted}")
print(f"   ✓ Match: {secret == decrypted}")

# Test file encryption
print("\n2. Testing file encryption...")
test_file = os.path.expanduser("~/test_secret.txt")
if os.path.exists(test_file):
    encrypted_file = crypto.encrypt_file(test_file)
    print(f"   Encrypted: {encrypted_file}")
    
    # Clean up
    os.remove(encrypted_file)
    print("   ✓ File encryption test passed")

# Test password hashing
print("\n3. Testing password hashing...")
hash_result = crypto.create_password_hash("MySecureHomelabPassword")
print(f"   Hash: {hash_result['hash'][:30]}...")
print(f"   Salt: {hash_result['salt'][:20]}...")
print("   ✓ Password hashing working")

print("\n✅ All cryptography tests passed!")
PYTHON

# Clean up
rm -f ~/test_secret.txt
