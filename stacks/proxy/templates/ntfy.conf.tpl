server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name ntfy.@DOMAIN@;
    include /etc/nginx/snippets/securite.conf;
    client_max_body_size 20m;
    proxy_buffering off;
    proxy_read_timeout 3h;
    location / {
        proxy_pass http://127.0.0.1:8011;
        include /etc/nginx/snippets/proxy.conf;
    }
}
