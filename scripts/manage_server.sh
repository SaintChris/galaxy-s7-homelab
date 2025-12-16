#!/data/data/com.termux/files/usr/bin/bash
case "$1" in
    start)
        echo "Starting Galaxy S7 Homelab..."
        sv up sshd && sv up nginx && sv up php-fpm
        echo "✓ Services started"
        echo "  SSH: ssh $(whoami)@$(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | head -1):8022"
        echo "  HTTP: http://$(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | head -1):8080"
        echo "  HTTPS: https://$(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | head -1):8443"
        ;;
    stop) 
        sv down nginx php-fpm sshd
        echo "Services stopped"
        ;;
    restart)
        $0 stop
        sleep 2
        $0 start
        ;;
    status)
        echo "=== Galaxy S7 Homelab Status ==="
        echo "SSH: $(sv status sshd 2>/dev/null | grep -o 'run' || echo 'down')"
        echo "NGINX: $(sv status nginx 2>/dev/null | grep -o 'run' || echo 'down')"
        echo "PHP-FPM: $(sv status php-fpm 2>/dev/null | grep -o 'run' || echo 'down')"
        echo "IP: $(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | head -1)"
        echo "Memory: $(free -m | awk '/Mem:/ {printf "%.1f%%", $3/$2*100}') used"
        ;;
    backup)
        BACKUP="homelab-$(date +%Y%m%d_%H%M%S).tar.gz"
        tar -czf ~/$BACKUP ~/www ~/ssl ~/scripts ~/*.py ~/*.sh 2>/dev/null
        echo "Backup created: ~/$BACKUP"
        ls -lh ~/$BACKUP
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|backup}"
        ;;
esac
