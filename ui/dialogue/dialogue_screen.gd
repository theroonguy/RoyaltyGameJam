extends Control

var active_character: Character
@onready var stop: Button = $HSplitContainer/VBoxContainer/MarginContainer/Stop
@onready var character: Button = %Character

func _ready() -> void:
	stop.pressed.connect(_on_stop)
	GameManager.screen_changed.connect(_on_screen_changed)
	character.pressed.connect(_on_character_pressed)

func start_dialogue():
	if active_character:
		active_character.dialogue.ref = self  # allows resource to run timers
		active_character.dialogue.run(active_character)
		character.icon = active_character.pic

func _on_stop():
	GameManager.change_screen(GameManager.Screen.CHARACTERS)

func _on_screen_changed(screen: int) -> void:
	if screen == GameManager.Screen.DIALOGUE:
		show()
	else:
		hide()


func _on_character_pressed() -> bool:
	if not character:
		printerr("no character selected!")
		return false
	
	if GameManager.selected_card:
		# if card selected, use it on character
		GameManager.use_card_on_character(GameManager.selected_card, active_character)
		return true
	
	return true
