# Journal des modifications

Les changements importants, du plus récent au plus ancien.

## 2026-11-06

- Wi-Fi de l'appartement en 2,4 GHz uniquement. La radio 5 GHz du routeur ne sert plus qu'au lien avec la résidence, dont les changements de canal déconnectaient le Nest Hub et, à travers lui, la lampe IKEA sur Thread.
- Home Assistant relance le serveur Matter quand un appareil Matter reste injoignable 10 minutes.
- La télé de mes parents accède à Jellyfin par Tailscale, et à rien d'autre : politique d'accès Tailscale, port 8443 dans nginx, pare-feu du Pi ([docs/reseau.md](docs/reseau.md#accès-à-distance-et-pare-feu)).

## 2026-11-04

- Reconnexion automatique au portail captif de la résidence, vérifiée chaque minute (`homelab-portail`).
- Essai de restauration complet le 8 de chaque mois (`homelab-onedrive essai`), avec sa sonde Uptime Kuma.
- Relecture d'un douzième des données sauvegardées chaque dimanche.
- restic 0.19.1 (binaire officiel, signature vérifiée) à la place de la version 0.14 de Debian, pour que la restauration reprenne après une coupure.
- Correction : AdGuard Home limitait tout l'appartement à 20 requêtes DNS par seconde.
- Correction : le script de sauvegarde pouvait tenter de recréer le dépôt sur une simple erreur réseau.
- Correction : une restauration en échec laissait un disque virtuel monté.
- Correction : Kiwix était marqué en échec à chaque mise en veille (code de sortie 143).
- Durcissement du système, score Lynis de 70 à 81 (détails dans [docs/securite.md](docs/securite.md#lynis)).
- Expiration de la clé Tailscale du Pi désactivée.
- Page d'accueil réorganisée, avec un capteur sur chaque tuile et une tuile « Sauvegardes ».
- Réservation d'adresse pour la montre connectée.

## 2026-11-03

- Services hors ligne : Wikipédia (Kiwix), IA locale (llama.cpp), médiathèque (Jellyfin) et carte de France (MapLibre, PMTiles), tous à la demande sauf la carte.
- `homelab-survie` pour télécharger et mettre à jour ces contenus.
- Correction : envois vers OneDrive interrompus par des flux HTTP/2 annulés.
- Correction : envoi de l'image hebdomadaire.
- Correction : page d'accueil vide après le retrait de Plex.

## 2026-11-02

- Sauvegardes hors site : copie chiffrée chaque nuit (restic) et image disque chaque dimanche, avec un kit de restauration.
- Alertes sur deux niveaux, critique ou silencieux.
- Mise à jour guidée d'Immich, avec une version figée (`homelab-immich`).
- Configuration du routeur ajoutée à la sauvegarde locale.
- Documentation sous forme de page web, copiée avec les sauvegardes.
- Nextcloud et Stirling-PDF démarrés à la demande.
- SSH par clé uniquement.
- Audit réseau de l'appartement et du routeur.
- Suppression de Plex.
- Suppression, sur le routeur, de la télé-administration du constructeur, du serveur WireGuard et du partage de fichiers.
- unbound n'écoute plus sur le réseau local et ne sert plus que le Pi.

## 2026-11-01

- Installation dans l'appartement étudiant : routeur en répéteur du Wi-Fi de la résidence, plan d'adressage par plages, réservations DHCP.
- Salle de contrôle : schéma du homelab, liaison réseau, plan d'adressage, domotique.
- Objets Matter sur Thread (IPv6 activé dans la VM Home Assistant).
- Suppression de n8n, Beszel et Vaultwarden, que je n'utilisais pas.
- Nettoyage de 171 entités orphelines dans Home Assistant.

## 2026-10-31

Début de ce journal. Le homelab existait déjà depuis plusieurs années, dans des versions successives. À cette date, il comprenait le Raspberry Pi 5 sur SSD NVMe, Home Assistant OS en machine virtuelle, les services Docker derrière nginx, le certificat générique, l'accès à distance par Tailscale, Uptime Kuma, Homepage, Immich et Nextcloud.
