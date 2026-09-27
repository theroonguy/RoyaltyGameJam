extends Control

const DIALOGUE_BOX = preload("uid://btptoqveg8uu4")

var queue: Array = []
var buttons: Array

func _ready() -> void:
	GameManager.dialogue_written.connect(_on_dialogue_write)
	GameManager.dialogue_split.connect(_on_split_dialogue)

func clear() -> void:
	for child in get_children():
		child.queue_free()

func _on_dialogue_write(text: String, character: Character) -> void:
	var new_dialogue = DIALOGUE_BOX.instantiate()
	add_child(new_dialogue)
	new_dialogue.setup(character)
	new_dialogue.write_text(text)

func _on_split_dialogue(text1: String, option1: Dialogue, text2: String, option2: Dialogue, character: Character) -> void:
	var button1 = Button.new()
	button1.text = text1
	var button2 = Button.new()
	button2.text = text2
	
	button1.position.x += 50
	add_child(button1)
	
	button2.position.x += 150
	add_child(button2)

	button1.pressed.connect(_on_option_chosen.bind(option1, character))
	button2.pressed.connect(_on_option_chosen.bind(option2, character))
	
	buttons.append(button1)
	buttons.append(button2)

func _on_option_chosen(option: Dialogue, character: Character) -> void:
	option.run(character)
	
	for button in buttons:
		if button:
			button.queue_free()
