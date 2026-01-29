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
