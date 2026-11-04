server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name cloud.@DOMAIN@;
    include /etc/nginx/snippets/hsts.conf;
    client_max_body_size 10G;
    client_body_timeout 300s;
    proxy_request_buffering off;
    location = /.well-known/carddav { return 301 /remote.php/dav; }
    location = /.well-known/caldav { return 301 /remote.php/dav; }
    location / {
        proxy_pass http://127.0.0.1:8002;
        include /etc/nginx/snippets/proxy.conf;
    }
}
