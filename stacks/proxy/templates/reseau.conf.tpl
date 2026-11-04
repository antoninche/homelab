server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name reseau.@DOMAIN@;
    include /etc/nginx/snippets/securite.conf;
    # API NetAlertX, protégée par son propre jeton (widget de la page d'accueil)
    # le widget Homepage appelle encore l'ancienne adresse PHP : même format de réponse que /devices/totals
    location = /api-netalertx/php/server/devices.php {
        proxy_pass http://127.0.0.1:20212/devices/totals;
    }
    location /api-netalertx/ {
        proxy_pass http://127.0.0.1:20212/;
        include /etc/nginx/snippets/proxy.conf;
    }
    location / {
        proxy_pass http://127.0.0.1:20211;
        include /etc/nginx/snippets/proxy.conf;
    }
}
