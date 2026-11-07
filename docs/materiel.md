# Matériel

| Élément | Modèle | Détails |
|---|---|---|
| Serveur | Raspberry Pi 5 Model B, 8 Go | 4 cœurs Cortex-A76 à 2,4 GHz, ventilateur piloté |
| Stockage | Samsung PM981 512 Go (`MZVLB512HBJQ`) | SSD NVMe sur le port PCIe du Pi, en Gen 2, démarrage sans carte SD |
| Routeur | GL.iNet Opal `GL-SFT1200` | Firmware 4.8.3 (OpenWrt), en répéteur du Wi-Fi de la résidence |
| Liaison | Câble Ethernet | Pi relié au routeur à 1 Gbit/s |

J'ai choisi un Raspberry Pi plutôt qu'un mini-PC pour la consommation (environ 6 W), le bruit et la place. Sa limite est la mémoire : 8 Go, c'est pour ça que plusieurs services ne tournent que quand je les utilise. Le système est sur un SSD NVMe parce qu'une carte SD s'use vite avec une base de données et une machine virtuelle qui écrivent en permanence. Je laisse le lien PCIe en Gen 2, le mode officiellement supporté par le Pi 5.

Le routeur GL.iNet se connecte au Wi-Fi de la résidence comme n'importe quel appareil et crée derrière lui le réseau de l'appartement, que je gère entièrement : adresses, réservations DHCP, DNS. Les autres résidents ne voient pas mes appareils. Comme il tourne sous OpenWrt, je peux l'administrer en SSH et sauvegarder sa configuration.

## Objets connectés

| Appareil | Liaison | Rôle |
|---|---|---|
| Aqara Camera Hub G3 | HomeKit | Aperçu photo, détection de mouvement, alarme, hub des capteurs Aqara |
| Capteur de porte, détecteur de mouvement, bouton Aqara | Zigbee, via la G3 | Sécurité de l'appartement |
| Capteur de présence Aqara FP2 | HomeKit | Présence dans l'appartement |
| Google Nest Hub | Cast | Écran et enceinte, routeur Thread pour les objets IKEA |
| Lampe IKEA VARMBLIXT, télécommande BILRESA | Matter sur Thread | Lumière avec une teinte qui suit l'heure |
| Prise Meross | Matter sur Wi-Fi | Lampe ronde, mesure de consommation |
| Sonde et passerelle Tuya | Cloud Tuya | Température et humidité extérieures |

Tout est regroupé dans Home Assistant. Certains objets restent aussi dans Google Home grâce au multi-administrateur de Matter.

## État du matériel

Relevé le 2026-11-04 :

| Mesure | Valeur |
|---|---|
| Usure du SSD | 13 %, aucune erreur |
| Données écrites sur le SSD | 54 To depuis sa fabrication |
| Températures | Processeur vers 50 °C, SSD vers 40 °C |
| Alimentation | 5,08 V, aucun bridage |
| Disque | 156 Go utilisés sur 470 Go |
| Mémoire | 5 Go utilisés sur 7,9 Go, dont 3 Go pour la VM Home Assistant |

L'essai de restauration mensuel relève aussi le compteur d'arrêts brutaux du SSD. S'il continue d'augmenter, j'ajouterai un petit onduleur.
