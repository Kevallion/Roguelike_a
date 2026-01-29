class_name HUD extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.signalBus.TakedDamage.connect(_on_takaDamageShow)


func _on_takaDamageShow(amount: int, g_position: Vector2) -> void:
	var amount_visual : AmountVisual = preload("uid://t2bueq4yyes5").instantiate()
	add_child(amount_visual)
	
	#calcule pour convertir la position monde vers ecran
	var canvas_transform = get_viewport().get_canvas_transform()
	var scren_position = canvas_transform * g_position
	
	amount_visual.position = scren_position + Vector2(0,-64)
	amount_visual.display_amount(amount)
	
	
