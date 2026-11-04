server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name outils.@DOMAIN@;
    include /etc/nginx/snippets/securite.conf;
    location / {
        proxy_pass http://127.0.0.1:8014;
        include /etc/nginx/snippets/proxy.conf;
    }
}
