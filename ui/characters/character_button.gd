@tool
extends Button
class_name CharacterButton

@onready var picture: TextureRect = %Picture
@onready var name_label: Label = %NameLabel

@export var show_on_day_1: bool = true

@export var character: Character:
	set(new_val):
		character = new_val
		
		if picture:
			setup_button()

signal selected

func _ready() -> void:
	pressed.connect(select_character)
	
	setup_button()
	
	if !show_on_day_1:
		hide()
	
	GameManager.day_updated.connect(_on_day_updated)

func _on_day_updated() -> void:
	show()

func setup_button():
	if not character:
		printerr("no character selected")
		return false
	
	if character.pic:
		picture.texture = character.pic
		picture.size = Vector2(100,100)
	
	size = Vector2(150,150)
	
	name_label.text = character.name

func select_character() -> bool:
	
	if not character:
		printerr("no character selected!")
		return false
	
	if GameManager.selected_card:
		# if card selected, use it on character
		GameManager.use_card_on_character(GameManager.selected_card, character)
		return true
	
	#if character.dialogue_chain:
		## if just selecting the character, open dialogue (for now)
		#character.dialogue_chain.run(character, self)
		#return true
	
	selected.emit()
	GameManager.talk_to_character(character)
	
	#printerr("no action available")
	
	return true


func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_SINE)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1).set_trans(Tween.TRANS_SINE)
