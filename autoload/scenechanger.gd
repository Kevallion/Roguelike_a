# Fichier: scenechanger.gd
# Rôle: Gère les transitions entre les différentes scènes du jeu.
# Il utilise un AnimationPlayer pour jouer une animation de fondu ("fade"),
# offrant une transition visuelle propre et douce lorsqu'on passe d'une scène à une autre.

class_name Scene_Changer extends CanvasLayer

var new_scene_path := ""

func change_scene_to(new_scene: String) -> void:
	print("chagne_scene_to", new_scene)
	new_scene_path = new_scene
	
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("fade in out")
	
func play_transition() -> void:
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("fade in out_level")
	
	await $AnimationPlayer.animation_finished
	
func _new_scene():
	var result = get_tree().change_scene_to_file(new_scene_path)
	if result != OK:
		push_error("Failed to load next level: " + new_scene_path + ". Qutting the galme")
		get_tree().quit()
