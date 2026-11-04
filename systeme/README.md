# Système

La configuration du système du Pi, rangée comme dans `/etc/`.

| Fichier | Rôle |
|---|---|
| [`etc/homelab/firewall.nft`](etc/homelab/firewall.nft) | Pare-feu nftables du Pi : refus par défaut, table dédiée |
| [`etc/homelab/homelab.env.exemple`](etc/homelab/homelab.env.exemple) | Configuration commune : domaine, fuseau horaire, sauvegardes locales |
| [`etc/sysctl.d/90-homelab.conf`](etc/sysctl.d/90-homelab.conf) | Paramètres du noyau : réseau, mémoire, durcissement |
| [`etc/sysctl.d/99-protect-links.conf`](etc/sysctl.d/99-protect-links.conf) | Remplace le fichier de même nom fourni par systemd, appliqué après le mien |
| [`etc/modprobe.d/homelab-blacklist.conf`](etc/modprobe.d/homelab-blacklist.conf) | Protocoles réseau inutiles et FireWire désactivés |
| [`etc/ssh/sshd_config.d/10-homelab.conf`](etc/ssh/sshd_config.d/10-homelab.conf) | SSH par clé uniquement, sans redirection de ports |
| [`etc/systemd/coredump.conf.d/90-homelab.conf`](etc/systemd/coredump.conf.d/90-homelab.conf) | Pas de fichiers core |
| [`etc/needrestart/conf.d/90-homelab.conf`](etc/needrestart/conf.d/90-homelab.conf) | needrestart signale les services à relancer, sans rien relancer |
| [`etc/lynis/custom.prf`](etc/lynis/custom.prf) | Faux positifs déclarés à Lynis |
| [`etc/issue`](etc/issue), [`etc/issue.net`](etc/issue.net) | Bannière d'avertissement |

Les explications sont dans [docs/securite.md](../docs/securite.md).
