# 0008. Reconnexion automatique au portail captif

- Statut : acceptée
- Date : 2026-11-04

## Contexte

Le Wi-Fi de la résidence passe par un portail captif. Quand la session expire, Internet est coupé pour tout l'appartement jusqu'à ce que quelqu'un se reconnecte sur la page du portail. Les 3 et 4 novembre 2026, deux coupures de 3 h et 7 h ont fait échouer le renouvellement du certificat, la sauvegarde hors site et l'essai de restauration, et coupé l'accès distant. Aucune alerte n'est partie, puisqu'elles passent par Internet.

## Options envisagées

- Se reconnecter à la main : impossible la nuit ou quand je suis absent, alors que les sauvegardes tournent la nuit.
- Reproduire la connexion de la page du portail dans un script.

## Décision

[`homelab-portail`](../../scripts/homelab-portail) tourne chaque minute par un minuteur systemd :

- il teste Internet avec une page qui répond `204`, dont le nom est résolu par le DNS de la résidence (AdGuard dépend lui-même d'Internet) ;
- après deux échecs à 10 secondes d'écart, il refait la connexion comme la page du portail, avec le compte stocké dans les secrets ;
- au plus une tentative toutes les 5 minutes, pour ne pas harceler le portail ;
- si le compte est refusé, il s'arrête, envoie une alerte critique et ne réessaie qu'après un changement des identifiants, pour éviter un blocage du compte ;
- chaque coupure est notée avec sa durée, et une notification silencieuse part au retour d'Internet.

La partie propre à l'opérateur (adresses, formulaires, jetons) est dans un fichier séparé, non publié.

## Conséquences

Avantages :

- Une coupure dure de 1 à 5 minutes au lieu de plusieurs heures.
- Les coupures sont mesurées : la salle de contrôle et la page d'accueil affichent le nombre de coupures sur 30 jours.

Inconvénients :

- Le script dépend du fonctionnement interne du portail : un changement côté opérateur peut le casser. L'échec est alors signalé dans le journal et visible dans la salle de contrôle.
- Le mot de passe du compte est stocké sur le Pi.
- Avant d'obtenir la bonne requête, six tentatives refusées ont été envoyées au portail ; d'où la règle d'arrêt après un refus.
