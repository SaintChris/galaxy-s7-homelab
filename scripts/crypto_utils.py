#!/usr/bin/env python3
"""
Galaxy S7 Homelab Cryptography Utilities
Simple encryption tools for your server
"""

from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
import base64
import os
import json

class HomelabCrypto:
    def __init__(self, key_file="~/.homelab_key"):
        self.key_file = os.path.expanduser(key_file)
        self.key = self._load_or_create_key()
        self.fernet = Fernet(self.key)
    
    def _load_or_create_key(self):
        """Load existing key or generate new one"""
        if os.path.exists(self.key_file):
            with open(self.key_file, 'rb') as f:
                return f.read()
        else:
            # Generate new key
            key = Fernet.generate_key()
            with open(self.key_file, 'wb') as f:
                f.write(key)
            os.chmod(self.key_file, 0o600)  # Secure permissions
            print(f"Generated new encryption key: {self.key_file}")
            return key
    
    def encrypt_string(self, plaintext):
        """Encrypt a string"""
        if isinstance(plaintext, str):
            plaintext = plaintext.encode()
        encrypted = self.fernet.encrypt(plaintext)
        return base64.urlsafe_b64encode(encrypted).decode()
    
    def decrypt_string(self, encrypted_text):
        """Decrypt a string"""
        encrypted = base64.urlsafe_b64decode(encrypted_text.encode())
        return self.fernet.decrypt(encrypted).decode()
    
    def encrypt_file(self, input_file, output_file=None):
        """Encrypt a file"""
        if output_file is None:
            output_file = input_file + '.enc'
        
        with open(input_file, 'rb') as f:
            data = f.read()
        
        encrypted = self.fernet.encrypt(data)
        
        with open(output_file, 'wb') as f:
            f.write(encrypted)
        
        print(f"Encrypted {input_file} -> {output_file}")
        return output_file
    
    def decrypt_file(self, input_file, output_file=None):
        """Decrypt a file"""
        if output_file is None:
            if input_file.endswith('.enc'):
                output_file = input_file[:-4]
            else:
                output_file = input_file + '.dec'
        
        with open(input_file, 'rb') as f:
            encrypted = f.read()
        
        decrypted = self.fernet.decrypt(encrypted)
        
        with open(output_file, 'wb') as f:
            f.write(decrypted)
        
        print(f"Decrypted {input_file} -> {output_file}")
        return output_file
    
    def create_password_hash(self, password, salt=None):
        """Create a secure password hash"""
        if salt is None:
            salt = os.urandom(16)
        
        kdf = PBKDF2HMAC(
            algorithm=hashes.SHA256(),
            length=32,
            salt=salt,
            iterations=100000,
        )
        
        key = base64.urlsafe_b64encode(kdf.derive(password.encode()))
        return {
            'hash': key.decode(),
            'salt': base64.urlsafe_b64encode(salt).decode()
        }

def test_crypto():
    """Test all crypto functions"""
    print("🧪 Testing Galaxy S7 Cryptography...")
    crypto = HomelabCrypto()
    
    # Test string encryption
    test_message = "Galaxy S7 Homelab Secret Data"
    encrypted = crypto.encrypt_string(test_message)
    decrypted = crypto.decrypt_string(encrypted)
    
    print(f"Original: {test_message}")
    print(f"Encrypted: {encrypted}")
    print(f"Decrypted: {decrypted}")
    print(f"Test passed: {test_message == decrypted}")
    
    # Test password hashing
    password = "MySecurePassword123"
    hash_result = crypto.create_password_hash(password)
    print(f"\nPassword hash created: {hash_result['hash'][:50]}...")
    
    return True

if __name__ == "__main__":
    test_crypto()
