class_name Unit_visual extends Node2D


@export var _anim : AnimationPlayer
@export var _visual: Node2D

var is_walking := false
func _process(delta: float) -> void:
	if is_walking:
		var time := Time.get_unix_time_from_system()
		position.y = sin(time * 19.5) * 2.0
	else:
		position.y = lerpf(position.y, 0.0, delta * 22)
		
func play_attack_animation(target_position: Vector2 ) -> void:
	print(target_position)
	var start_pos := global_position
	var tween := create_tween()
	var time := 0.2
	_visual.z_index = 10
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(_visual,"global_position",target_position,time)
	tween.tween_property(_visual,"global_position",start_pos,time)
	tween.finished.connect(func() -> void:
		_visual.z_index = 0
		)
	
	await tween.finished

func play_walk_animation(time: float) -> void:
	is_walking = true
	await get_tree().create_timer(time+1.0).timeout
	is_walking = false
