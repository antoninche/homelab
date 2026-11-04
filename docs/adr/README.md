# Décisions d'architecture

Les choix importants du homelab, avec le contexte, les options envisagées et les inconvénients de la solution retenue. J'utilise le format des ADR (Architecture Decision Records) de Michael Nygard. Quand une décision est remplacée, je garde l'ancienne en indiquant ce qui l'a remplacée.

| N° | Décision | Statut |
|---|---|---|
| [0001](0001-raspberry-pi-5-sur-ssd-nvme.md) | Un Raspberry Pi 5 sur SSD NVMe comme serveur unique | Acceptée |
| [0002](0002-acces-distant-par-tailscale.md) | Aucun port entrant, accès distant par Tailscale | Acceptée |
| [0003](0003-home-assistant-os-en-machine-virtuelle.md) | Home Assistant OS dans une machine virtuelle | Acceptée |
| [0004](0004-nginx-seul-point-d-entree.md) | nginx comme seul point d'entrée, certificat générique par défi DNS | Acceptée |
| [0005](0005-services-demarres-a-la-demande.md) | Services peu utilisés démarrés à la demande | Acceptée |
| [0006](0006-deux-sauvegardes-hors-site-et-essai-mensuel.md) | Deux sauvegardes hors site indépendantes et un essai de restauration mensuel | Acceptée |
| [0007](0007-alertes-sur-deux-niveaux.md) | Alertes sur deux niveaux | Acceptée |
| [0008](0008-reconnexion-automatique-au-portail-captif.md) | Reconnexion automatique au portail captif | Acceptée |

Les décisions 0001 à 0004 datent d'avant novembre 2026. Je les ai écrites après coup, le 2026-11-04.
