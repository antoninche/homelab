# Stacks

Une stack Docker Compose par dossier, installée dans `/opt/homelab/<stack>/` sur le Pi. La commande [`homelab`](../scripts/homelab) les démarre, les arrête et les met à jour ensemble.

| Stack | Images | Fonctionnement |
|---|---|---|
| [proxy](proxy/) | `nginx:1.31-alpine` | Permanent, seul point d'entrée |
| [homepage](homepage/) | `ghcr.io/gethomepage/homepage:v2.7.0` | Permanent |
| [uptime-kuma](uptime-kuma/) | `louislam/uptime-kuma:2-slim` | Permanent |
| [glances](glances/) | `nicolargo/glances:4.5.8-full` | Permanent |
| [netalertx](netalertx/) | `jokobsk/netalertx:26.10.0` | Permanent |
| [ntfy](ntfy/) | `binwiederhier/ntfy:v2.35.0` | Permanent |
| [dozzle](dozzle/) | `amir20/dozzle:v11.4.0` | Permanent |
| [portainer](portainer/) | `portainer/portainer-ce:2.45.3` | Permanent |
| [socket-proxy](socket-proxy/) | `lscr.io/linuxserver/socket-proxy:3.4.7` | Permanent, accès en lecture seule au socket Docker |
| [immich](immich/) | `immich-server:v3.3.5`, PostgreSQL 14 avec VectorChord, Valkey 9 | Permanent, version figée |
| [it-tools](it-tools/) | `corentinth/it-tools` | Permanent |
| [nextcloud](nextcloud/) | `nextcloud:35-apache`, `mariadb:11.8`, `redis:8-alpine` | À la demande |
| [stirling-pdf](stirling-pdf/) | `stirlingtools/stirling-pdf:3.2.2` | À la demande |
| [kiwix](kiwix/) | `ghcr.io/kiwix/kiwix-serve:3.8.2` | À la demande |
| [ia](ia/) | `ghcr.io/ggml-org/llama.cpp:server-b11977` | À la demande |
| [jellyfin](jellyfin/) | `jellyfin/jellyfin:12.4` | À la demande |

Home Assistant tourne dans une machine virtuelle et n'a donc pas de stack (voir l'[ADR 0003](../docs/adr/0003-home-assistant-os-en-machine-virtuelle.md)).

Les ports sont publiés sur `127.0.0.1` uniquement et nginx fait le lien avec l'extérieur. Chaque conteneur a l'option `no-new-privileges` et une limite de mémoire. Les secrets sont montés depuis `/etc/homelab/secrets/`. Les stacks à la demande ont `restart: "no"`, car c'est systemd qui les démarre et les arrête (voir [systemd/](../systemd/)). Le `.env` de chaque stack est un lien vers `/etc/homelab/homelab.env`, dont il y a un exemple dans [`systeme/etc/homelab/`](../systeme/etc/homelab/homelab.env.exemple).

Pour nginx, [`proxy/templates/`](proxy/templates/) contient un modèle par adresse, avec `@DOMAIN@` à la place du domaine, que `homelab render` écrit dans `conf.d/`. [`proxy/snippets/`](proxy/snippets/) regroupe les réglages communs (TLS, HSTS, en-têtes de sécurité, proxy). Le fichier `netalertx-api.conf`, qui contient le jeton de l'API NetAlertX, est généré par `homelab render` et n'est pas publié. [`proxy/site/noc/`](proxy/site/noc/) est la salle de contrôle et [`proxy/site/cartes/`](proxy/site/cartes/) la carte hors ligne, sans ses bibliothèques (MapLibre GL JS, pmtiles, basemaps de Protomaps), ses polices ni le fichier de carte.

[`homepage/config/`](homepage/config/) contient la page d'accueil : services, widgets et thème en CSS. Les valeurs entre `{{ }}` sont lues dans des fichiers secrets au démarrage du conteneur.
