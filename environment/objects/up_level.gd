class_name objectExit extends InteractiveObject

#next level to load
@export var next_level := PackedScene


func interact(unit: Unit) -> void:
	print("try to load next level")
	Globals.signalBus.nextLevelAsked.emit(next_level)
