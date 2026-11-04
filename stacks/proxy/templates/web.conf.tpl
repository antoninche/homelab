server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name web.@DOMAIN@;
    include /etc/nginx/snippets/securite.conf;
    location / {
        proxy_pass http://127.0.0.1:8081;
        include /etc/nginx/snippets/proxy.conf;
    }
}
