class_name CameraController extends Camera2D

@export var target : Unit

func _ready() -> void:
	zoom = Vector2(4.0,4.0)
	global_position = target.global_position
	

func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(target.global_position,delta * 10.0)
