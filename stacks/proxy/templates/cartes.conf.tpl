# Cartes hors ligne : page statique (source : /opt/homelab/proxy/site/cartes) et carte de France au format PMTiles
# (/srv/homelab/cartes/france.pmtiles), que la page lit par morceaux. Aucun programme en plus : nginx suffit.
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name cartes.@DOMAIN@;
    include /etc/nginx/snippets/securite.conf;
    root /usr/share/nginx/site/cartes;
    index index.html;
    gzip on;
    gzip_types application/json text/css text/javascript application/javascript application/x-protobuf;
    location / { try_files $uri $uri/ =404; expires -1; }
    location ~ \.mjs$ { types { } default_type text/javascript; expires 7d; }
    location ~ \.pbf$ { types { } default_type application/x-protobuf; expires 30d; }
    location /sprites/ { expires 30d; }
    location = /france.pmtiles { alias /usr/share/nginx/cartes/france.pmtiles; expires 1d; }
}
