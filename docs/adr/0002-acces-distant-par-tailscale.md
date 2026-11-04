# 0002. Aucun port entrant, accès distant par Tailscale

- Statut : acceptée
- Date : avant 2026-11, confirmée le 2026-11-01 lors de l'installation dans l'appartement, rédigée le 2026-11-04

## Contexte

Je veux joindre mes services depuis l'extérieur : photos, domotique, supervision. Dans la résidence, l'accès à Internet passe par un Wi-Fi partagé derrière un portail captif ; je ne contrôle ni la box ni le pare-feu, donc aucune redirection de port n'est possible. Même si elle l'était, exposer des services sur Internet ferait de chacun une cible.

## Options envisagées

- Redirection de ports : impossible derrière la box de la résidence, et je ne veux pas exposer de services de toute façon.
- Serveur WireGuard sur le routeur : demande lui aussi un port entrant ; le routeur en proposait un, désinstallé depuis.
- Tunnel inverse vers un service public (type Cloudflare Tunnel) : fonctionne sans port entrant, mais rend les services publics sur Internet, ce que je veux éviter.
- Réseau maillé Tailscale : connexions sortantes uniquement, chiffrement WireGuard, traversée de NAT, connexion directe entre appareils quand c'est possible et relais chiffré sinon.

## Décision

Aucun port entrant nulle part. Le Pi, l'iPhone et le Mac sont dans le même réseau Tailscale. Le nom DuckDNS du homelab pointe vers l'adresse Tailscale du Pi : hors de l'appartement, les adresses ne répondent que sur un appareil connecté à Tailscale. L'expiration de la clé du Pi est désactivée pour que l'accès ne s'arrête pas de lui-même.

## Conséquences

Avantages :

- Rien n'écoute publiquement sur Internet.
- Mêmes adresses dans l'appartement et dehors (voir les réécritures DNS dans [architecture.md](../architecture.md)).
- Fonctionne derrière n'importe quel réseau, y compris un portail captif.

Inconvénients :

- Dépendance à un service externe pour la coordination des appareils.
- Chaque appareil doit avoir Tailscale actif pour joindre le homelab de l'extérieur.
- Partager un service avec quelqu'un d'autre demande de l'inviter dans le réseau Tailscale.
