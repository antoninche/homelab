# Méthode

Je m'intéresse aux serveurs et à la domotique depuis plusieurs années, et j'ai tout appris en dehors des cours. Ce homelab est le résultat de ces années de travail, d'essais et de beaucoup de bugs, et la plupart des règles de ce dépôt viennent d'une panne ou d'une erreur. J'apprends mieux sur un système que j'utilise tous les jours et qui casse pour de bon que dans un tutoriel. J'ai utilisé l'IA pour avancer plus vite et apprendre en autodidacte, surtout pour comprendre un outil, comparer des options, relire une configuration ou chercher l'origine d'un problème.

## Habitudes

- Chaque service doit répondre à un usage réel. Ce qui ne sert plus est retiré ou mis en veille.
- Je me fixe des règles et je m'y tiens (elles sont dans [contexte.md](contexte.md)).
- J'écris les choix importants avec les options écartées et leurs inconvénients, dans les [décisions d'architecture](adr/README.md).
- Je ne considère pas un changement comme terminé tant que je ne sais pas l'expliquer.
- Je termine chaque changement par une vérification : une commande qui montre le résultat, une capture d'écran de la page, un test de charge sur le DNS, un essai de restauration.
- Les mots de passe sont écrits directement dans des fichiers lisibles par root et ne sont jamais affichés dans un terminal.
- Avant une suppression de données, un changement sur le routeur ou une action sur un service externe, je vérifie et je sauvegarde d'abord.
- Je ne scanne et n'analyse jamais le réseau de la résidence, seulement mes propres appareils.

## Ce que j'ai appris

- Le réseau : NAT, DHCP et réservations, DNS récursif et réécritures, DNS-over-HTTPS, VPN maillé, portail captif, IPv6 pour Matter et Thread.
- L'administration Linux : systemd (minuteurs, activation par socket, `OnFailure=`), nftables, Docker Compose, machines virtuelles KVM, durcissement du noyau et de SSH.
- La sécurité : partir des menaces réelles, lire un rapport d'audit, faire la différence entre un vrai risque et un faux positif.
- L'exploitation : garder les alertes rares pour qu'on les lise, tester les sauvegardes en restaurant, et se méfier des pannes qui ne font pas de bruit.
- Le diagnostic : remonter d'un symptôme vague, comme une musique qui coupe, jusqu'à la cause, ici une limite de débit DNS par client, en mesurant à chaque étape.
