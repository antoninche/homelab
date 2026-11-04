server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name site.@DOMAIN@;
    include /etc/nginx/snippets/securite.conf;
    root /usr/share/nginx/site;
    index index.html;
    # la salle de contrôle (dossier noc/) a son propre nom : pas de copie ici
    location ^~ /noc/ { return 404; }
    location ^~ /doc/ { return 404; }
    location / { try_files $uri $uri/ =404; expires -1; }
}
