extends Node2D


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_pressed("ui_accept"):
			Globals.scene_changer.change_scene_to("uid://bo4liidfra3e8")
		
