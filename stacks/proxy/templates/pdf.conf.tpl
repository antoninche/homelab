server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name pdf.@DOMAIN@;
    include /etc/nginx/snippets/securite.conf;
    client_max_body_size 2G;
    proxy_read_timeout 600s;
    location / {
        proxy_pass http://127.0.0.1:8008;
        include /etc/nginx/snippets/proxy.conf;
    }
}
