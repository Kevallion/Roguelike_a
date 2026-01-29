class_name SkillButton extends TextureButton

@onready var label_spell: Label = %Label_spell
@onready var label_key: Label = %label_key

var _skill : SkillsData
var is_seleted := false


var change_key = "":
	set(value):
		change_key = value
		label_key.text = value
		
		shortcut = Shortcut.new()
		var input_key = InputEventKey.new()
		input_key.keycode = value.unicode_at(0)
		shortcut.events = [input_key]
		
var change_spell= "":
	set(value):
		change_spell = value
		label_spell.text = value

var description := " "


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#on écoute également la selection des autre sort pour savoir si un autre est selectioné
	SignalBus.skill_seleted.connect(func(value: SkillsData ) -> void:
			if value != _skill and is_seleted:
				is_seleted = false
				print("Skill déselectioné ", _skill.skill_name)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# quand j'appuie sur un bonton je fais un tohle pour activer ou desactiver
func _on_pressed() -> void:
	is_seleted = not is_seleted
	if is_seleted:
		SignalBus.skill_seleted.emit(_skill)
		print("Skill selectioné ", _skill.skill_name)
	else:
		SignalBus.skill_seleted.emit(null)
		print("Skill déselectioné ", _skill.skill_name)
