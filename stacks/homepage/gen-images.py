# Génère les images de la page d'accueil : icône (icone.svg) et fond « verre » (fond-verre.svg).
# Usage : python3 gen-images.py <dossier de sortie>
import sys

out = sys.argv[1]
W, H = 1920, 1080


icone = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">
<defs><linearGradient id="a" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#14b8a6"/><stop offset="1" stop-color="#1e3a8a"/></linearGradient></defs>
<rect width="64" height="64" rx="15" fill="url(#a)"/>
<g stroke="#ecfeff" stroke-width="3.2" stroke-linecap="round" fill="none"><path d="M20 22 L42 18 M20 22 L32 44 M42 18 L32 44 M42 18 L48 38"/></g>
<g fill="#ecfeff"><circle cx="20" cy="22" r="5"/><circle cx="42" cy="18" r="4"/><circle cx="32" cy="44" r="6"/><circle cx="48" cy="38" r="3.5"/></g>
</svg>
'''
open(f"{out}/icone.svg", "w").write(icone)

# Fonds « verre » (2026-11) : base unie et quatre halos doux aux coins, mêmes valeurs que les pages
# du homelab (salle de contrôle, page de statut) et que le thème Home Assistant.
#   sombre : teal en haut à gauche, indigo en haut à droite, ciel en bas à gauche, rose en bas à droite
HALOS = [(0.08, 0.00), (0.92, 0.04), (0.06, 1.00), (0.96, 0.96)]  # centres, en fraction de la largeur / hauteur
RAYON = 0.70 * max(W, H)                                            # 70vmax, fondu jusqu'à 62 % du rayon
VERRE = {
    "fond-verre.svg": ("#0b1220", [("#2dd4bf", 0.30), ("#6366f1", 0.26), ("#38bdf8", 0.18), ("#ec4899", 0.14)]),
}
for nom, (base, couleurs) in VERRE.items():
    grads = "".join(
        f'<radialGradient id="h{i}" gradientUnits="userSpaceOnUse" cx="{cx * W:.0f}" cy="{cy * H:.0f}" r="{RAYON:.0f}">'
        f'<stop offset="0" stop-color="{c}" stop-opacity="{a}"/><stop offset=".62" stop-color="{c}" stop-opacity="0"/></radialGradient>'
        for i, ((cx, cy), (c, a)) in enumerate(zip(HALOS, couleurs)))
    calques = "".join(f'<rect width="{W}" height="{H}" fill="url(#h{i})"/>' for i in range(len(HALOS)))
    open(f"{out}/{nom}", "w").write(
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" preserveAspectRatio="xMidYMid slice">\n'
        f'<defs>{grads}</defs>\n<rect width="{W}" height="{H}" fill="{base}"/>\n{calques}\n</svg>\n')
print("fonds verre :", ", ".join(VERRE))
