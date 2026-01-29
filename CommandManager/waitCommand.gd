class_name WaitCommand extends Command

var duration: float

func _init(_duration: float = 0.2) -> void:
	duration = _duration

func execute() -> void:
	# On crée un timer temporaire pour attendre
	await (Engine.get_main_loop() as SceneTree).create_timer(duration).timeout
	finished.emit()
