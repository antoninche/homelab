# Unités systemd

Installées dans `/etc/systemd/system/` sur le Pi.

| Minuteur | Fréquence | Tâche |
|---|---|---|
| `homelab-noc.timer` | chaque minute | Données de la salle de contrôle et de la page d'accueil |
| `homelab-portail.timer` | chaque minute | Vérification d'Internet et reconnexion au portail captif |
| `homelab-duckdns.timer` | toutes les 5 min | Adresse DuckDNS et réécritures DNS |
| `homelab-certs.timer` | chaque nuit, 03:15 | Renouvellement du certificat |
| `homelab-sauvegarde.timer` | chaque nuit, 03:30 | Sauvegarde locale |
| `homelab-onedrive.timer` | chaque nuit, 04:15 | Copie de nuit vers OneDrive |
| `homelab-maj.timer` | dimanche, 04:30 | Mise à jour des conteneurs |
| `homelab-onedrive-image.timer` | dimanche, 05:00 | Image disque vers OneDrive |
| `homelab-onedrive-essai.timer` | le 8, 00:45 | Essai de restauration complet |

Les tâches importantes ont deux fichiers en plus dans leur dossier `.service.d/` : `kuma.conf`, qui signale la réussite à Uptime Kuma avec un `ExecStartPost`, et `alerte.conf`, qui envoie une alerte ntfy en cas d'échec avec `OnFailure=homelab-alerte@%n.service`. L'essai de restauration dure plusieurs heures, donc il tourne avec une priorité basse (`Nice=10`, `IOSchedulingClass=idle`).

Chaque service à la demande utilise trois unités : `homelab-<service>.socket` écoute sur `127.0.0.1:80xx` à la place du service, `homelab-<service>.service` lance le relais `systemd-socket-proxyd` et s'arrête après un délai sans activité, et `homelab-<service>-conteneur.service` démarre le conteneur puis l'arrête avec le relais. C'est le cas de `cloud` (Nextcloud), `pdf` (Stirling-PDF), `wiki` (Kiwix), `ia` (llama.cpp) et `films` (Jellyfin). Voir l'[ADR 0005](../docs/adr/0005-services-demarres-a-la-demande.md).

Il reste `homelab-firewall.service`, qui charge le pare-feu nftables au démarrage, `homelab-agrandir.service`, qui étend le système à tout le disque au premier démarrage après une restauration, et `homelab-alerte@.service`, qui envoie l'alerte pour l'unité passée en paramètre.
