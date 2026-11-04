server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name @DOMAIN@ home.@DOMAIN@;
    include /etc/nginx/snippets/securite.conf;
    location / {
        proxy_pass http://127.0.0.1:8001;
        include /etc/nginx/snippets/proxy.conf;
    }
}
