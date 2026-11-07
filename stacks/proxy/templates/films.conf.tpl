server {
    listen 443 ssl;
    listen [::]:443 ssl;
    # port réservé à la télé des parents (Tailscale) : sur 8443, nginx ne sert que Jellyfin ; le pare-feu
    # du Pi ne laisse la télé joindre que ce port (voir /etc/homelab/firewall.nft)
    listen 8443 ssl;
    listen [::]:8443 ssl;
    server_name films.@DOMAIN@;
    include /etc/nginx/snippets/securite.conf;
    # lecture en continu et sans tampon ; les apps gardent une connexion WebSocket ouverte
    proxy_buffering off;
    client_max_body_size 50M;
    location / {
        proxy_pass http://127.0.0.1:8022;
        include /etc/nginx/snippets/proxy.conf;
    }
}
