extends Control

const DIALOGUE_BOX = preload("uid://btptoqveg8uu4")

var num_messages: int = 0

var queue: Array = []

func _ready() -> void:
	GameManager.dialogue_written.connect(_on_dialogue_write)

func _on_dialogue_write(text: String, character: Character) -> void:
	var new_dialogue = DIALOGUE_BOX.instantiate()
	new_dialogue.position.y = num_messages * 50.0
	add_child(new_dialogue)
	new_dialogue.setup(character)
	new_dialogue.write_text(text)
	num_messages += 1
