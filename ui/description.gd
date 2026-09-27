extends PanelContainer

@onready var label: RichTextLabel = %Label

var total_text: String = ""

var buttons: Array = []
const CHOICE = preload("uid://c0v3t6de6foii")
@onready var h_box_container: HBoxContainer = $HBoxContainer

func _ready() -> void:
	GameManager.write_status.connect(_on_write_status)
	GameManager.dialogue_split.connect(_on_split_dialogue)
	
	label.text = ""

func _on_write_status(text: String) -> void:
	# get all text and make it gray
	label.text = "[color=dimgray]" + total_text + "[/color]"
	label.text += "\n"
	total_text += "\n"
	for i in text:
		label.text += i
		total_text += i
		await get_tree().create_timer(0.03).timeout

func _on_split_dialogue(text1: String, option1: Dialogue, text2: String, option2: Dialogue, character: Character) -> void:
	if GameManager.current_screen == GameManager.Screen.DIALOGUE:
		return
	
	var button1 = CHOICE.instantiate()
	button1.text = text1
	var button2 = CHOICE.instantiate()
	button2.text = text2
	
	button1.position.x += 50
	h_box_container.add_child(button1)
	
	button2.position.x += 150
	h_box_container.add_child(button2)

	button1.pressed.connect(_on_option_chosen.bind(option1, character))
	button2.pressed.connect(_on_option_chosen.bind(option2, character))
	
	buttons.append(button1)
	buttons.append(button2)


func _on_option_chosen(option: Dialogue, character: Character) -> void:
	option.run(character)
	
	for button in buttons:
		if button:
			button.queue_free()
