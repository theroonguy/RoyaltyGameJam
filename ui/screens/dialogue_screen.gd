extends Control

var active_character: Character
var active_dialogue: Dialogue
@onready var stop: Button = %Stop
@onready var character: Button = %Character

@onready var dialogue_region: Control = %DialogueRegion

var can_leave: bool = true

func _ready() -> void:
	stop.pressed.connect(_on_stop)
	GameManager.screen_changed.connect(_on_screen_changed)
	GameManager.interacted_with_character.connect(_on_interacted_with_character)
	GameManager.card_played_on_character.connect(_on_card_played_on_character)
	character.pressed.connect(_on_character_pressed)

func setup_dialogue():
	dialogue_region.clear()
	character.icon = active_character.pic
	GameManager.change_screen(GameManager.Screen.DIALOGUE)

func start_dialogue():
	if active_character:
		if not active_character.dialogue:
			printerr("no dialogue assigned")
			return
		
		setup_dialogue()
		active_dialogue = active_character.dialogue
		active_dialogue.run(active_character)
		
		can_leave = false
		#await GameManager.end_dialogue
		can_leave = true

func _on_stop():
	if not can_leave:
		return
	GameManager.change_screen(GameManager.last_location)

func _on_screen_changed(screen: int) -> void:
	if screen == GameManager.Screen.DIALOGUE:
		show()
	else:
		hide()

func _on_card_played_on_character(card: Card, character: Character) -> void:
	for interaction in character.interactions:
		if interaction.card == card:
			active_dialogue = interaction.dialogue
			setup_dialogue()
			active_dialogue.run(character)

func _on_interacted_with_character(character: Character) -> void:
	active_character = character
	start_dialogue()

func _on_character_pressed() -> bool:
	if not character:
		printerr("no character selected!")
		return false
	
	if GameManager.selected_card:
		# if card selected, use it on character
		GameManager.use_card_on_character(GameManager.selected_card, active_character)
		return true
	
	return true
