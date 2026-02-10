class_name AI_Action extends RefCounted

var command: Command
var score: float = 0.0

func _init(_command: Command, _score: float = 0.0):
	command = _command
	score = _score
