# Galaxy S7 Homelab

A complete homelab running on a Samsung Galaxy S7 smartphone.

## Directory Structure

```
homelab/
├── web/           - All web content
├── scripts/       - Management and automation scripts
├── configs/       - Configuration files
├── ansible/       - Infrastructure as Code
├── services/      - Service installations
├── data/          - Backups, logs, uploads
├── docs/          - Documentation
└── security/      - Security tools
```

## Quick Start

```bash
# Check service status
~/homelab/scripts/core/manage_server.sh status

# Start all services
~/homelab/scripts/core/manage_server.sh start

# Restart specific service
~/homelab/scripts/core/manage_server.sh restart nginx
```

## Documentation

See the `docs/` directory for detailed documentation.
