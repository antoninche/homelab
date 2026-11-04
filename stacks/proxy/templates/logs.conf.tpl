server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name logs.@DOMAIN@;
    include /etc/nginx/snippets/securite.conf;
    proxy_buffering off;
    proxy_cache off;
    location / {
        proxy_pass http://127.0.0.1:8007;
        include /etc/nginx/snippets/proxy.conf;
    }
}
