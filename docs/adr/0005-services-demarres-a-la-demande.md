# 0005. Services peu utilisés démarrés à la demande

- Statut : acceptée
- Date : 2026-11-02, étendue le 2026-11-03 aux services hors ligne

## Contexte

La mémoire est la ressource rare du Pi ([0001](0001-raspberry-pi-5-sur-ssd-nvme.md)). Plusieurs services sont utiles mais rarement ouverts : Nextcloud et sa base, Stirling-PDF, et plus tard Kiwix, l'IA locale et Jellyfin. Ensemble, éveillés, ils prendraient plus de 4 Go. Le principe du projet est que rien ne tourne pour rien.

## Options envisagées

- Tout laisser tourner : la mémoire ne suffit pas avec l'IA locale, et le reste tournerait pour rien la plupart du temps.
- Les retirer : perte de fonctions utiles de temps en temps.
- Les démarrer à la main : contraignant, et facile à oublier.
- Activation par socket systemd : systemd écoute à la place du service et le démarre à la première connexion.

## Décision

Pour chaque service concerné, trois unités systemd :

1. `homelab-<service>.socket` écoute sur `127.0.0.1:80xx`, là où nginx envoie les requêtes ;
2. à la première connexion, `homelab-<service>.service` lance `systemd-socket-proxyd`, qui relaie vers le conteneur et s'arrête après un délai sans activité (`--exit-idle-time`) ;
3. `homelab-<service>-conteneur.service` démarre le conteneur (`docker start -a`) et attend qu'il réponde ; il l'arrête quand le relais s'arrête.

Les conteneurs ont `restart: "no"` et sont exclus du démarrage global (`ONDEMAND` dans la commande `homelab`).

## Conséquences

Avantages :

- En veille, ces services ne prennent ni mémoire ni processeur.
- L'IA locale (jusqu'à 3 Go) devient possible sur un Pi qui fait déjà tourner tout le reste.

Inconvénients :

- Délai au premier accès : de 2 secondes (Kiwix) à 1 minute (Stirling-PDF).
- Rien ne doit les réveiller par erreur : pas de sonde Uptime Kuma, pas de widget qui interroge leur API, intégration Nextcloud de Home Assistant désactivée, sauvegarde qui reprend le dernier export de base pendant la veille. La page d'accueil et la salle de contrôle lisent leur état dans un fichier écrit par le Pi.
- Un service en veille n'est pas surveillé : une panne n'apparaît qu'à la visite suivante.
