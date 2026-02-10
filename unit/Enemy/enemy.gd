class_name Enemy extends Unit

var _player: Player
var is_sleeping : bool = true 
@export var view_range : float = 160.0

# Le cerveau de l'IA
var brain: AI_Brain

func _ready() -> void:
	super._ready() # Appel du _ready de Unit (important pour l'initialisation de la grille)
	brain = AI_Brain.new()
	# Le cerveau sera initialisé au premier appel de get_intention ou manuellement
	
## Retourne la commande que l'ennemi souhaite exécuter
func get_intention(board: GameBoard) -> Command:
	# Initialisation tardive du cerveau si nécessaire
	# (on le fait ici car on est sûr d'avoir le board et le player valide à ce moment là)
	if brain._unit == null:
		brain.initialize(self, board)
		
	# Si l'ennemi dort ou si le joueur n'est pas visible, on attend
	# Note: On garde cette logique d'optimisation ici pour éviter de faire tourner le cerveau pour rien
	if not is_instance_valid(_player) or not _is_player_in_view_range():
		return WaitCommand.new(self, 0.1)

	return brain.decide()

func _is_player_in_view_range() -> bool:
	if is_instance_valid(_player):
		return _player.global_position.distance_to(global_position) < view_range
	return false

func die() -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_sleeping = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_sleeping = true
