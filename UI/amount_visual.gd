class_name AmountVisual extends Node2D

@onready var label: Label = %Label


func display_amount(amount: float) -> void:
	label.text = str(amount)
