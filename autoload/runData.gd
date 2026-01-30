# Fichier: runData.gd
# Rôle: Conserve toutes les données relatives à la partie en cours ("run").
# C'est ici que l'état persistant de la progression du joueur est stocké,
# comme l'étage actuel, les points de vie restants, l'inventaire, et la séquence
# des niveaux à parcourir. Ces données sont réinitialisées au début de chaque nouvelle partie.
##Core du projet il va sauvegarder pas mal de données.
extends Node

var current_floor_index: int
var player_health: int
var inventory : Array
var corruption_level: int
var level_list : Array[PackedScene]

func init_run(starting_stat) -> void:
	pass
