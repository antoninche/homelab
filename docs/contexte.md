# Contexte

Je m'intéresse aux serveurs et à la domotique depuis longtemps. Ce homelab a été construit petit à petit sur plusieurs années, avec pas mal d'essais, de réinstallations et de bugs, d'abord chez mes parents puis dans mon appartement étudiant.

J'étudie l'informatique, mais le réseau et la sécurité ne sont pas au programme. Je voulais comprendre comment un nom de domaine devient une adresse, comment accéder à un service sans l'exposer sur Internet, comment savoir qu'un serveur va mal et comment tout reconstruire après une panne. Le plus simple pour l'apprendre était d'avoir un système que j'utilise tous les jours.

## Contraintes

L'appartement est dans une résidence étudiante. Le seul accès à Internet est le Wi-Fi de la résidence, un réseau ouvert partagé avec les autres résidents et protégé par un portail captif : il faut s'identifier sur une page web, et la session expire au bout d'un moment. Quand elle expire, Internet est coupé pour tout l'appartement jusqu'à la connexion suivante. Je ne contrôle ni la box ni le pare-feu de la résidence, donc aucun port entrant n'est possible. Le débit mesuré est d'environ 45 Mbit/s en réception et 17 Mbit/s en émission.

Tout doit tenir sur un Raspberry Pi 5 de 8 Go sans carte graphique. La mémoire est la ressource qui manque le plus, d'autant que la machine virtuelle de Home Assistant en prend 3 Go.

Enfin, je ne veux pas avoir à surveiller le serveur tous les jours. Il doit redémarrer seul ce qui plante, me prévenir quand il faut intervenir, et pouvoir être reconstruit à l'identique si le Pi ou son disque lâche.

## Règles

Avec le temps, je me suis fixé quelques règles :

1. Un service qui ne sert plus est supprimé, et un service rarement utilisé ne démarre que lorsqu'on l'ouvre.
2. nginx, en HTTPS, est le seul point d'entrée vers les services, qui n'écoutent que sur le Pi.
3. Rien n'est ouvert sur Internet : l'accès à distance passe par Tailscale.
4. Les alertes ont deux niveaux. Seules celles qui demandent une action font sonner le téléphone.
5. Les sauvegardes sont testées par une vraie restauration, automatiquement, chaque mois.
6. Je ne garde pas de copies de fichiers du type `.avant-modification`, les sauvegardes servent à ça.
7. Après chaque changement, je mets la documentation à jour.
8. Une mesure de sécurité qui gêne au quotidien sans protéger d'un risque réel n'est pas appliquée. Ces cas sont listés dans [securite.md](securite.md).

Au quotidien, le homelab me sert pour le DNS sans publicité de tout l'appartement, la domotique (sécurité, lumières, consommation électrique), la sauvegarde des photos de l'iPhone avec Immich, et une encyclopédie, une IA et des cartes qui marchent même sans Internet. C'est aussi l'endroit où je teste des choses.
