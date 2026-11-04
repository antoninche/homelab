# Sécurité

Aucun mot de passe, jeton ni clé n'est publié dans ce dépôt. Ils sont générés sur le Pi par `homelab secrets` et rangés dans `/etc/homelab/secrets/`. Les fichiers de configuration y font référence par leur chemin (`secrets:` de Docker Compose, variables `_FILE`).

J'ai aussi remplacé le nom de domaine, les adresses publiques et Tailscale, les adresses MAC et les noms de personnes, y compris sur les captures d'écran. La partie du script de connexion au portail captif propre à l'opérateur Wi-Fi n'est pas publiée. Avant de publier, j'ai comparé le dépôt aux valeurs réelles de tous les secrets du serveur, sans trouver de correspondance.

Si vous trouvez une information sensible oubliée ou une faiblesse dans une configuration, ouvrez une issue sans donner de détail exploitable et je vous recontacterai.

Ces configurations supposent un accès limité au réseau local et à Tailscale. Elles ne sont pas prévues pour être exposées sur Internet.
