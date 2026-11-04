# 0007. Alertes sur deux niveaux

- Statut : acceptée
- Date : 2026-11-02

## Contexte

Uptime Kuma, Home Assistant, NetAlertX et les tâches planifiées peuvent tous envoyer des notifications. Avec une trentaine de sondes, chaque retour à la normale, chaque appareil qui se connecte et chaque mise à jour finissaient sur le téléphone. Avec autant de notifications, je finissais par ne plus les lire.

## Options envisagées

- Tout notifier : c'était la situation de départ, avec trop de notifications.
- Plusieurs niveaux fins (info, avertissement, erreur, critique) : difficile à régler de façon cohérente entre quatre outils.
- Deux niveaux : il faut agir, ou pas.

## Décision

Toutes les alertes passent par ntfy, hébergé sur le Pi, dans un seul sujet, avec deux niveaux :

- critique (priorité haute, avec son) : quelque chose demande une action, comme une sauvegarde en échec, un service essentiel en panne ou un appareil inconnu ;
- silencieux (priorité basse) : visible dans ntfy, sans son ni vibration.

Une nouvelle sonde est silencieuse par défaut. Les connexions d'appareils connus ne sont pas notifiées. Le niveau de chaque source est réglé à un seul endroit par outil : la notification choisie dans Uptime Kuma, le champ `priority` dans Home Assistant, la liste en tête de [`homelab-alerte`](../../scripts/homelab-alerte) pour les tâches planifiées.

## Conséquences

Avantages :

- Une notification avec son signifie toujours qu'il faut agir.
- L'historique complet reste consultable dans ntfy.

Inconvénients :

- Une alerte silencieuse peut passer inaperçue si elle annonce un problème qui s'aggrave. Les retours à la normale aident à suivre l'évolution.
- ntfy passe par un relais Internet pour joindre l'iPhone : sans Internet, aucune alerte ne part.
