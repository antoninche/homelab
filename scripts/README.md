# Scripts

Les commandes du homelab, installées dans `/usr/local/sbin/` sur le Pi. Elles lisent la configuration dans `/etc/homelab/homelab.env` et les secrets dans `/etc/homelab/secrets/`, qui ne sont pas dans ce dépôt. Elles sont écrites en Bash et en Python 3, avec des paquets Debian courants (`python3-websocket` pour parler à Home Assistant).

| Commande | Rôle | Lancée par |
|---|---|---|
| [`homelab`](homelab) | Démarrer, arrêter et mettre à jour les stacks, régénérer nginx et la page d'accueil, créer les secrets manquants | À la main, et `homelab-maj.timer` le dimanche |
| [`homelab-sauvegarde`](homelab-sauvegarde) | Sauvegarde locale : exports des bases, configurations, données, configuration du routeur | `homelab-sauvegarde.timer`, 03:30 |
| [`homelab-sauvegarde-ha`](homelab-sauvegarde-ha) | Copie la dernière sauvegarde automatique de Home Assistant | `homelab-sauvegarde` |
| [`homelab-onedrive`](homelab-onedrive) | Copie de nuit chiffrée, image du dimanche, essai de restauration, restauration, récupération de fichiers | Trois minuteurs (voir [systemd/](../systemd/)) |
| [`homelab-certs`](homelab-certs) | Renouvelle le certificat générique par défi DNS (lego) | `homelab-certs.timer`, chaque nuit |
| [`homelab-duckdns`](homelab-duckdns) | Publie l'adresse Tailscale du Pi chez DuckDNS et règle les réécritures DNS d'AdGuard | `homelab-duckdns.timer`, toutes les 5 min |
| [`homelab-portail`](homelab-portail) | Vérifie Internet et se reconnecte au portail captif de la résidence | `homelab-portail.timer`, chaque minute |
| [`homelab-noc`](homelab-noc) | Écrit les données de la salle de contrôle et de la page d'accueil | `homelab-noc.timer`, chaque minute |
| [`homelab-kuma-push`](homelab-kuma-push) | Signale à Uptime Kuma qu'une tâche a réussi | `ExecStartPost` des tâches planifiées |
| [`homelab-alerte`](homelab-alerte) | Envoie une alerte ntfy quand une tâche planifiée échoue | `OnFailure=` des tâches planifiées |
| [`homelab-immich`](homelab-immich) | Mise à jour d'Immich, avec un export de la base avant | À la main |
| [`homelab-survie`](homelab-survie) | Télécharge et met à jour les bibliothèques Kiwix, les modèles de l'IA et la carte | À la main |
| [`ha-vm-exec`](ha-vm-exec) | Lance une commande dans la VM Home Assistant par l'agent invité QEMU | Autres scripts |

Quelques exemples :

```sh
sudo homelab status                               # état de tous les conteneurs
sudo homelab-onedrive etat                        # copies, images et place utilisée
sudo homelab-onedrive recuperer /etc/homelab      # récupérer un dossier depuis la dernière nuit
sudo systemctl start homelab-onedrive-essai       # essai de restauration complet tout de suite
sudo homelab-portail etat                         # état d'Internet et dernières coupures
sudo homelab-survie                               # contenus hors ligne installés ou manquants
```

`homelab-portail` est la version publique du script : la partie propre à l'opérateur Wi-Fi de la résidence est dans un fichier séparé que je ne publie pas (voir l'[ADR 0008](../docs/adr/0008-reconnexion-automatique-au-portail-captif.md)). La fonction `identifiants` de `homelab-onedrive` regroupe les accès du homelab dans un fichier rangé avec les sauvegardes, pour pouvoir tout reconstruire sans le Pi. Ce fichier n'est pas publié.
