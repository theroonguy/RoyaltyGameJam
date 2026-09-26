extends Control

const CHARACTER_BUTTON = preload("uid://hmtbkg5gav52")
@onready var dialogue_screen: PanelContainer = $"../DialogueScreen"

func _ready() -> void:
	refresh()
	
	GameManager.character_killed.connect(_on_character_killed)
	GameManager.screen_changed.connect(_on_screen_changed)

func _on_screen_changed(screen: int) -> void:
	if screen == GameManager.Screen.CHARACTERS:
		show()
	else:
		hide()

func _on_character_killed(character: Character) -> void:
	refresh()

func refresh() -> void:
	for child in get_children():
		if child is Button:
			child.queue_free()
	
	for character: Character in GameManager.characters:
		var new_button = CHARACTER_BUTTON.instantiate()
		new_button.text = character.name
		new_button.position.x = GameManager.characters.find(character) * 150.0
		new_button.character = character
		add_child(new_button)
		new_button.selected.connect(_on_selected.bind(character))

func _on_selected(character: Character) -> void:
	dialogue_screen.active_character = character
	dialogue_screen.start_dialogue()
	GameManager.change_screen(GameManager.Screen.DIALOGUE)
