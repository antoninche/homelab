server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name ia.@DOMAIN@;
    include /etc/nginx/snippets/securite.conf;
    # réponses envoyées mot à mot (flux) ; un premier message peut attendre que le modèle se charge
    proxy_buffering off;
    proxy_cache off;
    proxy_read_timeout 900s;
    client_max_body_size 50M;
    location / {
        proxy_pass http://127.0.0.1:8021;
        include /etc/nginx/snippets/proxy.conf;
    }
}
