# Fichier: signalBus.gd
# Rôle: Sert de "Bus d'Événements" (Event Bus) global pour le jeu.
# Il permet une communication découplée entre les différents objets et systèmes.
# Au lieu de liens directs, un objet peut émettre un signal sur le bus (par exemple, `player_died`),
# et n'importe quel autre objet peut s'y connecter pour réagir, sans qu'ils aient à se connaître.
#
# Signaux disponibles:
# - player_died: Émis lorsque le joueur meurt.
# - TakedDamage: Émis lorsqu'une unité subit des dégâts, avec le montant et la position.
# - skill_inited: Émis lorsque les compétences du joueur sont initialisées.
# - skill_seleted: Émis lorsqu'une compétence est sélectionnée par le joueur.

extends Node

signal player_died
signal TakedDamage(amount: int, g_position: Vector2)
signal skill_inited(skills: Array[SkillsData])
signal skill_selected(skill)
signal nextLevelAsked(level: PackedScene)
