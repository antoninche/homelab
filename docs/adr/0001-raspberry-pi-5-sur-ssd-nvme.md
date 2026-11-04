# 0001. Un Raspberry Pi 5 sur SSD NVMe comme serveur unique

- Statut : acceptée
- Date : avant 2026-11, rédigée le 2026-11-04

## Contexte

Le serveur vit dans une chambre d'étudiant : il doit être silencieux, peu encombrant et consommer peu, puisqu'il tourne jour et nuit. Il doit porter une machine virtuelle (Home Assistant OS), une vingtaine de conteneurs et des sauvegardes quotidiennes. Les bases de données et la VM écrivent en continu sur le disque.

## Options envisagées

- Mini-PC x86 d'occasion : plus de mémoire et de puissance, tout logiciel disponible. Écarté : consommation plus élevée, ventilateur plus présent, encombrement.
- Raspberry Pi 5 sur carte SD : le plus simple. Écarté : une carte SD s'use vite sous des écritures continues, et ses performances aléatoires pénalisent les bases et la VM.
- Raspberry Pi 5 sur SSD NVMe : consommation de l'ordre de 6 W, silencieux, virtualisation KVM disponible, stockage rapide et durable.

## Décision

Un Raspberry Pi 5 de 8 Go, démarrant sur un SSD NVMe Samsung PM981 de 512 Go branché sur son port PCIe, sans carte SD. Le lien PCIe reste en Gen 2, le mode officiellement pris en charge ; le Gen 3 n'apporterait pas de gain visible pour cet usage.

## Conséquences

Avantages :

- Le SSD s'use peu : 13 % d'usure relevée.
- Une seule machine à sauvegarder, à surveiller et à restaurer.

Inconvénients :

- 8 Go de mémoire, dont 3 réservés à la VM, donc il faut faire des choix pour chaque nouveau service. C'est ce qui m'a amené aux services démarrés à la demande ([0005](0005-services-demarres-a-la-demande.md)).
- Architecture ARM : quelques images Docker n'existent pas pour elle.
- Pas d'encodeur vidéo matériel : la médiathèque doit servir des fichiers déjà lisibles par tous les appareils.
- Si le Pi tombe en panne, tout s'arrête, y compris le DNS de l'appartement.
