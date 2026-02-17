class_name AiAction  extends RefCounted

var command : Command
var score :  float
var name : String 

func _init(_command: Command, _score: float , _name: String = "") -> void:
	command = _command
	score = _score
	name = _name
