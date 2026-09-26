extends Control

const CHARACTER_BUTTON = preload("uid://hmtbkg5gav52")

func _ready() -> void:
	for character: Character in GameManager.characters:
		var new_button = CHARACTER_BUTTON.instantiate()
		new_button.text = character.name
		new_button.position.x = GameManager.characters.find(character) * 150.0
		new_button.character = character
		add_child(new_button)


func _on_go_back_button_pressed() -> void:
	GameManager.change_screen(GameManager.Screen.MAP)
