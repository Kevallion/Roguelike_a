class_name Scene_Changer extends CanvasLayer

var new_scene_path := ""


func change_scene_to(new_scene: String) -> void:
	print("chagne_scene_to", new_scene)
	new_scene_path = new_scene
	
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("fade in out")
	
	
	
func _new_scene():
	var result = get_tree().change_scene_to_file(new_scene_path)
	if result != OK:
		push_error("Failed to load next level: " + new_scene_path + ". Qutting the galme")
		get_tree().quit()
