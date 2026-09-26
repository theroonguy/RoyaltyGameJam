extends Control

const CHARACTER_BUTTON = preload("uid://hmtbkg5gav52")

func _ready() -> void:
	refresh()
	
	GameManager.character_killed.connect(_on_character_killed)

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
