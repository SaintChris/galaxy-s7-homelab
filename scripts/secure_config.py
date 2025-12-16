#!/usr/bin/env python3
"""
Secure Configuration Manager for Galaxy S7 Homelab
Store sensitive data (passwords, API keys) encrypted
"""

import json
import os
from pathlib import Path
from crypto_utils import HomelabCrypto

class SecureConfig:
    def __init__(self, config_file="~/.homelab_config.enc"):
        self.config_file = os.path.expanduser(config_file)
        self.crypto = HomelabCrypto()
        self.config = self._load_config()
    
    def _load_config(self):
        """Load and decrypt configuration"""
        if os.path.exists(self.config_file):
            try:
                decrypted = self.crypto.decrypt_file(self.config_file, "/dev/stdout")
                return json.loads(decrypted)
            except:
                print("⚠️  Config file corrupted or wrong key. Starting fresh.")
                return {}
        else:
            return {}
    
    def save_config(self):
        """Encrypt and save configuration"""
        config_json = json.dumps(self.config, indent=2)
        
        # Create temporary file
        temp_file = self.config_file + ".tmp"
        with open(temp_file, 'w') as f:
            f.write(config_json)
        
        # Encrypt it
        self.crypto.encrypt_file(temp_file, self.config_file)
        os.remove(temp_file)
        
        # Secure permissions
        os.chmod(self.config_file, 0o600)
        print(f"✓ Configuration saved securely to {self.config_file}")
    
    def set(self, key, value):
        """Set a configuration value"""
        self.config[key] = value
        self.save_config()
    
    def get(self, key, default=None):
        """Get a configuration value"""
        return self.config.get(key, default)
    
    def delete(self, key):
        """Delete a configuration value"""
        if key in self.config:
            del self.config[key]
            self.save_config()
            return True
        return False
    
    def list_all(self):
        """List all configuration keys (without values)"""
        return list(self.config.keys())

# Example usage for your homelab
def setup_homelab_config():
    config = SecureConfig()
    
    # Set up initial configuration
    config.set("homelab_name", "Galaxy S7 Homelab")
    config.set("ssh_port", 8022)
    config.set("http_port", 8080)
    config.set("https_port", 8443)
    config.set("admin_email", "admin@homelab.local")
    
    # You can add sensitive data too
    # config.set("api_key", "YOUR_SECRET_API_KEY")
    # config.set("db_password", "SecureDBPass123")
    
    print("✅ Homelab configuration initialized!")
    print(f"Config keys: {config.list_all()}")
    
    # Test retrieval
    print(f"Homelab name: {config.get('homelab_name')}")
    print(f"SSH port: {config.get('ssh_port')}")

if __name__ == "__main__":
    setup_homelab_config()
