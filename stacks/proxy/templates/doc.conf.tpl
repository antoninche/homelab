# Documentation du homelab : page statique (source : /opt/homelab/proxy/site/doc/index.html), copiée aussi dans OneDrive
# chaque nuit par homelab-onedrive. Comme tout le homelab : réseau local et Tailscale seulement.
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name doc.@DOMAIN@;
    include /etc/nginx/snippets/securite.conf;
    root /usr/share/nginx/site/doc;
    index index.html;
    location / { try_files $uri $uri/ =404; expires -1; }
}
