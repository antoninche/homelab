# Sécurité

| Risque | Réponse |
|---|---|
| Attaque depuis Internet | Rien n'est exposé, aucun port ouvert. L'accès à distance passe par Tailscale. |
| Autres résidents sur le Wi-Fi partagé | Le routeur de l'appartement refuse tout ce qui vient du réseau de la résidence. |
| Appareil inconnu dans l'appartement | NetAlertX envoie une alerte critique, et le pare-feu du Pi limite les ports accessibles. |
| Panne, erreur de manipulation, disque mort | Sauvegardes hors site, image flashable, essai de restauration mensuel ([sauvegardes-et-restauration.md](sauvegardes-et-restauration.md)). |
| Compte de stockage compromis | Double authentification sur le compte. Le kit de restauration, clé du dépôt comprise, est rangé au même endroit pour pouvoir tout reconstruire sans le Pi. |

Je considère le réseau de l'appartement comme sûr, puisque j'y suis seul. Ça explique plusieurs mesures que je n'applique pas, listées plus bas.

## Mesures en place

- Aucun port entrant, ni sur le routeur ni ailleurs. Accès à distance uniquement par Tailscale.
- Pare-feu nftables sur le Pi, refus par défaut. SSH, HTTP et HTTPS seulement depuis le réseau local et Tailscale. fail2ban sur SSH.
- DNS chiffré (DNS-over-HTTPS) avec DNSSEC, publicités et pistage bloqués pour tout l'appartement.
- Routeur allégé : j'ai désinstallé la télé-administration du constructeur, le serveur VPN et le partage de fichiers, ce qui ferme les ports correspondants.
- SSH par clé uniquement, sans mot de passe et sans redirection de ports.
- Secrets générés sur le Pi dans `/etc/homelab/secrets/`, lisibles par root seulement et passés aux conteneurs par fichiers.
- HTTPS partout, avec HSTS et des en-têtes de sécurité ([`securite.conf`](../stacks/proxy/snippets/securite.conf)).
- Services liés à `127.0.0.1` derrière nginx, `no-new-privileges` et limite de mémoire sur tous les conteneurs, socket Docker en lecture seule pour la supervision, bases de données sur des réseaux internes.
- Versions des images fixées. Immich, qui change souvent de fonctionnement, est mis à jour à la main après lecture des notes de version, avec un export de la base avant.
- Correctifs de sécurité Debian automatiques (unattended-upgrades) et AppArmor actif.

## Lynis

[Lynis](https://cisofy.com/lynis/) audite le système chaque nuit. Le 2026-11-04, je suis passé de 70 à 81 avec des changements qui ne gênent pas l'usage :

| Domaine | Changement | Fichier |
|---|---|---|
| Noyau | Routage source refusé, paquets anormaux journalisés, liens et FIFO protégés, `perf_event` restreint, chargement des disciplines de ligne coupé | [`90-homelab.conf`](../systeme/etc/sysctl.d/90-homelab.conf), [`99-protect-links.conf`](../systeme/etc/sysctl.d/99-protect-links.conf) |
| Modules | DCCP, SCTP, RDS, TIPC et FireWire désactivés | [`homelab-blacklist.conf`](../systeme/etc/modprobe.d/homelab-blacklist.conf) |
| Fichiers core | Désactivés | [`coredump.conf.d`](../systeme/etc/systemd/coredump.conf.d/90-homelab.conf) |
| SSH | Compression coupée, journal détaillé, deux sessions par connexion au plus | [`10-homelab.conf`](../systeme/etc/ssh/sshd_config.d/10-homelab.conf) |
| Permissions | Compilateurs réservés à root, configuration SSH et crontab lisibles par root seul | |
| Outils | debsums, apt-show-versions, needrestart (qui signale sans rien relancer), libpam-tmpdir, paquets résiduels purgés | [`needrestart`](../systeme/etc/needrestart/conf.d/90-homelab.conf) |
| Divers | Bannière d'avertissement, nom de domaine local, tours de hachage des mots de passe augmentés | [`issue`](../systeme/etc/issue) |

Deux choses m'ont fait perdre du temps. systemd fournit son propre `99-protect-links.conf`, appliqué après le mien, qui remettait `protected_fifos` à 1 ; il a fallu créer un fichier du même nom dans `/etc/sysctl.d/` pour le remplacer. Et Lynis ne reconnaît un module désactivé que sous la forme `install <module> /bin/true`, pas avec `/bin/false`.

Le fichier [`custom.prf`](../systeme/etc/lynis/custom.prf) déclare deux faux positifs : le mode promiscuité d'`eth0`, qui sert de pont réseau à la VM Home Assistant, et un « redémarrage nécessaire » dû au noyau du Pi 4, que je garde pour qu'une image puisse démarrer sur un Pi 4 en dépannage.

## Choix assumés

Certaines recommandations de Lynis ou des guides de durcissement ne sont pas appliquées :

| Mesure | Raison |
|---|---|
| Expiration et complexité imposées des mots de passe | Aucune connexion par mot de passe n'est possible à distance. |
| Port SSH non standard | Le port n'est joignable que depuis le réseau local et Tailscale. |
| Masque de fichiers `027` | Il casserait les pages servies par nginx. |
| Partitions séparées | Elles compliqueraient l'image flashable, pour peu de gain sur une machine à un seul usage. |
| Journalisation à distance | Je n'ai pas d'autre machine pour la recevoir. |
| Blocage des clés USB | Elles servent à restaurer. |
| Transfert IP désactivé | Docker et la VM en ont besoin. |
| `sudo` sans mot de passe | L'accès SSH se fait par clé, et un mot de passe gênerait les scripts. |
| Images disque non chiffrées | Elles doivent se flasher telles quelles. Le compte de stockage est protégé par double authentification. |

Je réfléchis encore à `auditd`, AIDE et à un détecteur de rootkits, qui tourneraient en permanence.

## Durée de vie

| Point | Risque | Réponse |
|---|---|---|
| Portail captif | Internet coupé pendant des heures, sauvegardes et accès à distance arrêtés | Reconnexion automatique, en place |
| Restauration | Jamais réussie de bout en bout au départ | Essai automatique chaque mois, en place |
| Stockage hors site | Lié au compte étudiant, qui disparaîtra après les études | Trouver une seconde destination |
| Debian 12 | Correctifs de sécurité jusqu'au 30 juin 2028 | Passer à Debian 13 en 2027 |
| Coupures de courant | Pas d'onduleur | Compteur d'arrêts brutaux du SSD relevé chaque mois |
