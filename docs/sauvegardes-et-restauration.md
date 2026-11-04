# Sauvegardes et restauration

| Sauvegarde | Quand | Où | Contenu | Conservation |
|---|---|---|---|---|
| Home Assistant | chaque nuit, 03:00 | dans la VM | Configuration de Home Assistant, chiffrée | 3 |
| Locale | chaque nuit, 03:30 | sur le Pi | Exports des bases, photos, fichiers Nextcloud, configurations, sauvegarde de Home Assistant, configuration du routeur | 3 nuits |
| Copie de nuit | chaque nuit, 04:15 | OneDrive, dépôt restic | Tout le système, chiffré et dédupliqué | 7 nuits, 5 dimanches, 12 mois |
| Image disque | dimanche, 05:00 | OneDrive | Le disque entier compressé, prêt à flasher | 2 |
| Essai de restauration | le 8 du mois, 00:45 | sur le Pi | Vérifie la dernière image et restaure la dernière copie de nuit | rapport |

Les deux sauvegardes hors site sont indépendantes : si le dépôt restic est abîmé, l'image reste utilisable, et inversement (voir l'[ADR 0006](adr/0006-deux-sauvegardes-hors-site-et-essai-mensuel.md)).

La nuit, les tâches s'enchaînent ainsi : audit Lynis à 00:30, sauvegarde de Home Assistant à 03:00, vérification du certificat HTTPS à 03:15 (renouvelé 30 jours avant son expiration), sauvegarde locale à 03:30, copie vers OneDrive à 04:15. Le dimanche, les conteneurs sont mis à jour à 04:30, sauf Immich, puis l'image disque part à 05:00. Comme l'image est faite avant les mises à jour, elle permet de revenir en arrière.

## Copie de nuit

[`homelab-onedrive`](../scripts/homelab-onedrive) ne sauvegarde pas directement le système en marche. Il tient à jour un miroir du disque dans un fichier image local. Un premier passage `rsync` met le miroir à jour pendant que tout tourne. Ensuite, les conteneurs sont mis en pause et la VM suspendue le temps d'un second passage court, pour que les bases soient cohérentes. Puis tout redémarre et restic envoie le miroir dans OneDrive par rclone, chiffré et dédupliqué, en n'envoyant que les blocs modifiés.

Le dimanche, restic relit un douzième des données stockées (`check --read-data-subset`), ce qui fait le tour complet en 12 semaines. Le même miroir sert à produire l'image du dimanche. Il a un identifiant de disque différent de celui du Pi pour ne jamais être confondu avec le vrai disque, et l'identifiant réel est remis dans l'image à la compression.

Les contenus qui se retéléchargent ne sont pas copiés hors site : bibliothèques Kiwix, modèles de l'IA, carte de France et cache de Jellyfin, soit environ 34 Go. `homelab-survie telecharger` les remet après une restauration. Un plafond de 300 Go protège le stockage : au-delà, les images les plus anciennes sont supprimées et une alerte critique part.

## Restauration

Le dossier OneDrive contient un kit de restauration : le script, une copie de restic, l'accès au stockage, la clé du dépôt et un guide en texte.

Si le Pi ou son disque est mort, il suffit de télécharger l'image la plus récente et de l'écrire avec Raspberry Pi Imager (« image personnalisée ») sur le SSD branché en USB, ou sur une carte SD d'au moins 128 Go. On remet le disque, on branche l'Ethernet et on allume. Au premier démarrage, `homelab-agrandir.service` étend le système à tout le disque, et tout répond au bout de 3 à 5 minutes avec les mêmes adresses, la même identité Tailscale, les mêmes certificats et le même Home Assistant.

Pour revenir à une nuit précise, on démarre le Pi sur une carte SD Raspberry Pi OS avec le SSD branché, on copie le kit sur le Pi et on lance :

```sh
sudo bash restauration/homelab-onedrive etat                        # copies disponibles
sudo bash restauration/homelab-onedrive restaurer /dev/nvme0n1      # la plus récente
sudo bash restauration/homelab-onedrive restaurer /dev/nvme0n1 1a2b3c4d
```

Le téléchargement prend 2 à 3 heures par le Wi-Fi de la résidence. S'il est coupé, il reprend où il s'était arrêté, jusqu'à six fois (`restic restore --overwrite if-changed`).

Pour récupérer un seul fichier ou dossier :

```sh
sudo homelab-onedrive recuperer /srv/homelab/immich/library            # depuis la dernière nuit
sudo homelab-onedrive recuperer /etc/homelab 1a2b3c4d                  # depuis une copie précise
```

Les fichiers arrivent dans `/root/recuperation-<date>/`, sans toucher au système en place.

## Essai mensuel

Le 8 de chaque mois, `homelab-onedrive essai` :

1. met à jour restic ;
2. télécharge la dernière image et vérifie son empreinte ;
3. restaure la dernière copie de nuit sur un disque virtuel, comme sur un SSD neuf ;
4. monte le résultat en lecture seule et le compare au Pi avec `rsync` en simulation (l'essai échoue au-delà de 50 différences) ;
5. compare la partition de démarrage, vérifie le disque de la VM (`qemu-img check`) et les exports de bases (`gzip -t`) ;
6. relève l'usure du SSD et son compteur d'arrêts brutaux ;
7. envoie le résultat : signal à Uptime Kuma et notification silencieuse si tout va bien, alerte critique sinon.

Le premier essai complet, en novembre 2026, a échoué à cause d'une coupure d'Internet. restic 0.14, la version de Debian, ne savait pas reprendre une restauration interrompue, et le script laissait le disque virtuel monté après l'échec. J'ai installé restic 0.19.1, ajouté la reprise automatique et le nettoyage en fin de script, puis automatisé l'essai chaque mois.
