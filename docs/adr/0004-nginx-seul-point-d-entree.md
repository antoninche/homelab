# 0004. nginx comme seul point d'entrée, certificat générique par défi DNS

- Statut : acceptée
- Date : avant 2026-11, rédigée le 2026-11-04

## Contexte

Une vingtaine de services web tournent sur le Pi, chacun sur son port. Je veux une adresse lisible par service, du HTTPS valide partout (sans avertissement du navigateur, y compris pour les applications iPhone) et un seul endroit où appliquer les règles de sécurité. Aucun port entrant n'est disponible ([0002](0002-acces-distant-par-tailscale.md)), donc Let's Encrypt ne peut pas valider le domaine par HTTP.

## Options envisagées

- Accès direct par port : pas de HTTPS commun, des en-têtes de sécurité à régler service par service.
- Traefik ou Caddy avec découverte automatique : pratique, mais ajoute une couche de magie et l'accès au socket Docker.
- nginx avec un fichier par service et un certificat générique : plus de configuration à écrire, mais je sais exactement ce que fait chaque fichier.

## Décision

nginx est le seul point d'entrée. Chaque service a son modèle (`stacks/proxy/templates/<service>.conf.tpl`), rendu avec le domaine par `homelab render`. Les conteneurs n'écoutent que sur `127.0.0.1`. Un certificat Let's Encrypt générique (`*.exemple.duckdns.org`) est obtenu et renouvelé par [lego](https://go-acme.github.io/lego/) avec un défi DNS chez DuckDNS, chaque nuit s'il reste moins de 30 jours. Les extraits communs (`snippets/`) ajoutent HSTS, les en-têtes de sécurité et les réglages de proxy.

## Conséquences

Avantages :

- Un seul certificat, valable pour tous les services, y compris ceux ajoutés plus tard.
- Les règles de sécurité sont au même endroit.
- Les services démarrés à la demande ne demandent rien de particulier : nginx envoie les requêtes au socket systemd, qui réveille le conteneur.

Inconvénients :

- Ajouter un service demande d'écrire son modèle nginx.
- Dépendance à DuckDNS pour le nom et pour la validation du certificat. Une panne de DuckDNS bloque le renouvellement, avec plusieurs semaines de marge.
