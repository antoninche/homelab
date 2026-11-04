# 0003. Home Assistant OS dans une machine virtuelle

- Statut : acceptée
- Date : avant 2026-11, rédigée le 2026-11-04

## Contexte

Home Assistant est le cœur de la domotique. Il existe en conteneur simple ou en système complet (Home Assistant OS). Seul le système complet gère les applications (AdGuard Home, Matter Server, terminal), les sauvegardes intégrées et les mises à jour guidées. Le Pi héberge aussi une vingtaine d'autres conteneurs que je veux gérer moi-même.

## Options envisagées

- Home Assistant en conteneur Docker : léger, mais sans applications, donc il faudrait installer et maintenir à la main AdGuard, le serveur Matter et le reste.
- Home Assistant OS seul sur le Pi : expérience complète, mais le Pi ne pourrait plus héberger librement les autres services.
- Un second appareil dédié : plus de matériel, plus de consommation, deux machines à sauvegarder.
- Home Assistant OS dans une machine virtuelle KVM sur le Pi.

## Décision

Home Assistant OS tourne dans une machine virtuelle libvirt de 3 Go et 2 cœurs. Elle a une interface sur le réseau de l'appartement (`192.168.8.11`), pour la découverte des objets et pour Matter et Thread, et un lien privé avec le Pi (`10.99.0.0/24`). AdGuard Home y tourne comme application et sert de DNS à tout l'appartement.

## Conséquences

Avantages :

- Toutes les fonctions de Home Assistant OS, sans renoncer à la liberté sur le reste du Pi.
- La VM est un seul fichier disque, sauvegardé avec le reste du système.

Inconvénients :

- 3 Go de mémoire réservés, soit près de 40 % du Pi.
- L'interface de la VM ne peut pas joindre l'adresse locale de son propre hôte : il a fallu un lien privé et des réponses DNS différentes selon le client (`10.99.0.1` pour Home Assistant, `192.168.8.10` pour les autres).
- IPv6 doit rester actif dans la VM pour Matter et Thread.
- Les commandes dans la VM passent par l'agent invité QEMU ([`ha-vm-exec`](../../scripts/ha-vm-exec)).
