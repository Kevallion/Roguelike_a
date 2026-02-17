class_name LevelLoader extends Node2D


var current_level : Node2D
@export var level_to_load : PackedScene

func _ready() -> void:
	Globals.signalBus.nextLevelAsked.connect(loadlevel)
	for child: Node2D in get_children():
		child.queue_free()
	
	loadlevel(level_to_load)
	
func loadlevel(newLevel: PackedScene) -> void:
	
	
	#unload level
	if current_level != null:
		current_level.queue_free()
	
	#play transition	
	await Globals.scene_changer.play_transition()
	
	#loadlevel
	current_level = newLevel.instantiate()
	add_child(current_level)
