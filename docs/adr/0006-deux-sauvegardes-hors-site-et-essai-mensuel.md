# 0006. Deux sauvegardes hors site indépendantes et un essai de restauration mensuel

- Statut : acceptée
- Date : 2026-11-02, essai mensuel ajouté le 2026-11-04

## Contexte

Le Pi contient des données qui n'existent nulle part ailleurs : photos, configuration de la domotique, historique. Une sauvegarde locale ne protège ni contre la mort du SSD ni contre un vol ou un incendie. Le stockage disponible hors site est le OneDrive de mon compte étudiant (1 To). Le budget que je m'accorde est de 300 Go. L'envoi passe par le Wi-Fi de la résidence, lent en émission.

Je veux deux façons de revenir : une très simple (flasher une image, sans rien taper) et une précise (revenir à une nuit donnée, ou récupérer un seul fichier).

## Options envisagées

- Copie de fichiers vers le cloud (rclone sync) : simple, mais pas d'historique, pas de chiffrement, pas de déduplication.
- restic seul : historique, chiffrement et déduplication, mais une restauration complète demande d'installer un système avant.
- Image disque seule : restauration triviale, mais lourde à envoyer chaque nuit et sans historique fin.
- restic chaque nuit et image chaque semaine.

## Décision

- Chaque nuit, un miroir local du disque est mis à jour (services figés le temps d'un second passage), puis envoyé par restic dans OneDrive, chiffré et dédupliqué. Conservation : 7 nuits, 5 dimanches, 12 mois.
- Chaque dimanche, ce miroir est compressé en image flashable avec Raspberry Pi Imager. Deux images sont gardées.
- Un kit de restauration accompagne les sauvegardes : script, binaire restic, accès au stockage, guide en texte simple.
- Le 8 de chaque mois, un essai de restauration complet vérifie l'image et restaure la dernière copie de nuit, puis la compare au Pi.
- Le dimanche, restic relit un douzième des données stockées : tout est relu en 12 semaines.
- Les contenus retéléchargeables (environ 34 Go) sont exclus.

## Conséquences

Avantages :

- Deux chemins de retour indépendants, dont un sans aucune commande.
- La restauration est vérifiée chaque mois.
- Une restauration interrompue par une coupure reprend là où elle s'était arrêtée (restic 0.17 et plus, `--overwrite if-changed`).

Inconvénients :

- Le miroir local occupe environ 35 Go sur le SSD.
- Restaurer une image demande un support d'au moins 128 Go.
- Les images ne sont pas chiffrées, pour rester flashables sans outil : la protection repose sur la double authentification du compte.
- Le stockage dépend du compte étudiant, qui disparaîtra après les études : une seconde destination sera nécessaire.
