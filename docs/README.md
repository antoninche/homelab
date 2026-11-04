# Documentation

- [Contexte](contexte.md) : d'où vient le projet, les contraintes de la résidence, les règles que je me suis fixées.
- [Matériel](materiel.md) : le Pi, le SSD, le routeur, les objets connectés.
- [Architecture](architecture.md) : le trajet d'une connexion, le DNS, la machine virtuelle, l'organisation des fichiers.
- [Réseau](reseau.md) : plan d'adressage, DNS, accès à distance, portail captif, pare-feu.
- [Services](services.md) : la liste des services, ceux qui démarrent à la demande, la partie hors ligne.
- [Supervision et alertes](supervision-et-alertes.md) : Uptime Kuma, la salle de contrôle, les alertes.
- [Sauvegardes et restauration](sauvegardes-et-restauration.md) : les niveaux de sauvegarde, la restauration, l'essai mensuel.
- [Sécurité](securite.md) : les menaces prises en compte, les mesures en place, l'audit Lynis.
- [Méthode](methode.md) : comment je travaille sur le projet.
- [Décisions d'architecture](adr/README.md) : les choix importants et leurs compromis.

Pour le détail des fichiers : [scripts](../scripts/README.md), [tâches planifiées](../systemd/README.md), [stacks](../stacks/README.md) et le [journal des modifications](../CHANGELOG.md).

Dans toute la documentation, le domaine réel est remplacé par `exemple.duckdns.org`, et les adresses publiques, adresses MAC et noms de personnes ont été changés. Le réseau de l'appartement (`192.168.8.0/24`) est celui que le routeur utilise par défaut.
