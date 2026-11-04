# Salle de contrôle : page statique + API de supervision en lecture seule, sans mot de passe
# (comme tout le homelab, joignable seulement depuis le réseau local et Tailscale).
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name noc.@DOMAIN@;
    include /etc/nginx/snippets/securite.conf;
    root /usr/share/nginx/site/noc;
    index index.html;
    location / { try_files $uri $uri/ =404; expires -1; }
    # faits de l'hôte, régénérés chaque minute par homelab-noc
    location /data/ { expires -1; }
    # Glances : mesures en direct (aussi lu par Homepage et Home Assistant)
    location /api/4/ {
        limit_except GET { deny all; }
        proxy_pass http://127.0.0.1:61208;
    }
    # Uptime Kuma : page de statut publique
    location /api/kuma/ {
        limit_except GET { deny all; }
        proxy_pass http://127.0.0.1:8005/api/status-page/;
    }
    # NetAlertX : inventaire des appareils, deux routes en lecture seule
    location = /api/reseau/devices {
        limit_except GET { deny all; }
        include /etc/nginx/snippets/netalertx-api.conf;
        proxy_pass http://127.0.0.1:20212/devices;
    }
    location = /api/reseau/totals {
        limit_except GET { deny all; }
        include /etc/nginx/snippets/netalertx-api.conf;
        proxy_pass http://127.0.0.1:20212/devices/totals;
    }
}
