server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name photos.@DOMAIN@;
    include /etc/nginx/snippets/hsts.conf;
    client_max_body_size 50000M;
    client_body_timeout 600s;
    proxy_request_buffering off;
    proxy_buffering off;
    proxy_read_timeout 600s;
    proxy_send_timeout 600s;
    location / {
        proxy_pass http://127.0.0.1:8012;
        include /etc/nginx/snippets/proxy.conf;
    }
}
