# Fichier: globals.gd
# Rôle: Fait office de "Service Locator" pour le projet. Il fournit un point d'accès global
# et centralisé à toutes les instances des principaux managers (singletons) du jeu,
# comme le gestionnaire d'état (Gamestate), de scènes (SceneChanger), etc.
# Cela simplifie l'accès à ces managers depuis n'importe quel autre script.

extends Node

var state : Gamestate
var scene_changer : Scene_Changer
var runData : RunData
var signalBus : SignalBus
var audio_manager : AudioManager

func _ready() -> void:
	state = Gamestate
	runData = RunData
	signalBus = SignalBus
	scene_changer = SceneChanger
	audio_manager = AudioManager
