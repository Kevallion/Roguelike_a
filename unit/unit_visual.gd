class_name Unit_visual extends Node2D


@export var _anim : AnimationPlayer
@export var _visual: Node2D

var is_walking := false

##function qui lance l'annimation d'attaque	
func play_attack_animation(target_position: Vector2 ) -> void:
	
	var local_target := to_local(target_position)
	var direction = local_target.normalized()
	var bump_vector = direction * 8.0
	
	var tween := create_tween()
	_visual.z_index = 10
	
	#var vers la direction du bump
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(_visual,"position",bump_vector,0.1)
	
	#retourne à ta position
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(_visual,"position",Vector2.ZERO,0.25)
	
	await tween.finished
	_visual.z_index = 0

##function qui fait sautiller l'unité	
func play_jump_animation(step_duration: float) -> void:
	# On coupe la durée en deux : montée et descente
	var half_step_duration = step_duration / 2.0
	
	var tween := create_tween()
	var jump_height = 8.0
	var jump_vector = Vector2.UP * jump_height
	#1. Montée (Ease OUT pour ralentir en haut)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_visual,"position",jump_vector,half_step_duration)
	
	# 2. Descente (Ease IN pour accélérer en bas)
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_visual,"position",Vector2.ZERO,half_step_duration)

##function pour faire changer le regard de unité
func face_direction(direction: Vector2) -> void:
	# Si la direction.x est supérieure à 0 (droite), on met le scale.x à 1i
	if direction.x > 0:
		scale.x = 1
	# Si la direction.x est inférieure à 0 (gauche), on met le scale.x à -1
	if direction.x < 0:
		scale.x = -1
