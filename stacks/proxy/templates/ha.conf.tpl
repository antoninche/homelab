server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name ha.@DOMAIN@;
    include /etc/nginx/snippets/hsts.conf;
    proxy_buffering off;
    location / {
        proxy_pass http://10.99.0.10;
        include /etc/nginx/snippets/proxy.conf;
    }
}
