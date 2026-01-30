class_name SkillButton extends TextureButton

@onready var label_spell: Label = %Label_spell
@onready var label_key: Label = %label_key

var _skill : SkillsData
var is_selected := false


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
	Globals.signalBus.skill_selected.connect(func(value: SkillsData ) -> void:
			if value != _skill and is_selected:
				is_selected = false
				print("Skill déselectioné ", _skill.skill_name)
	)


# quand j'appuie sur un bonton je fais un togle pour activer ou desactiver
func _on_pressed() -> void:
	is_selected = not is_selected
	if is_selected:
		Globals.signalBus.skill_selected.emit(_skill)
		print("Skill selectioné ", _skill.skill_name)
	else:
		Globals.signalBus.skill_selected.emit(null)
		print("Skill déselectioné ", _skill.skill_name)
