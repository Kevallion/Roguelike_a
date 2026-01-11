class_name Command extends RefCounted

signal finished

func execute() -> void:
	push_error("execute() Must be implemented in child class")
	
