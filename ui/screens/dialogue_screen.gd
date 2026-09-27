extends Control

var active_character: Character
var active_dialogue: Dialogue
@onready var stop: Button = %Stop
@onready var character: Button = %Character

@onready var dialogue_region: Control = %DialogueRegion
@onready var character_name_label: Label = %CharacterNameLabel
@onready var stats: Label = %Stats
@onready var progress_bar: ProgressBar = $MarginContainer/HSplitContainer/VBoxContainer/CenterContainer/VBoxContainer/ProgressBar

var can_leave: bool = true

var in_influence_check: bool = false

func _ready() -> void:
	stop.pressed.connect(_on_stop)
	GameManager.screen_changed.connect(_on_screen_changed)
	GameManager.interacted_with_character.connect(_on_interacted_with_character)
	GameManager.card_played_on_character.connect(_on_card_played_on_character)
	GameManager.influence_check.connect(_on_influence_check)
	character.pressed.connect(_on_character_pressed)

func setup_dialogue():
	dialogue_region.clear()
	character.icon = active_character.pic
	character_name_label.text = active_character.name
	stats.text = "Influence: %s" % [active_character.influence]
	GameManager.change_screen(GameManager.Screen.DIALOGUE)

func start_dialogue():
	if active_character:
		if not active_character.dialogue:
			printerr("no dialogue assigned")
			return
		
		setup_dialogue()
		if GameManager.days_left == 3:
			active_dialogue = active_character.dialogue
		elif GameManager.days_left == 2:
			if not active_character.dialogue2:
				active_dialogue = active_character.dialogue
			else:
				active_dialogue = active_character.dialogue2
		elif GameManager.days_left == 1:
			if not active_character.dialogue3:
				if not active_character.dialogue2:
					active_dialogue = active_character.dialogue
				else: 
					active_dialogue = active_character.dialogue2
			else: 
				active_dialogue = active_character.dialogue3
		active_dialogue.run(active_character)
		
		can_leave = false
		#await GameManager.end_dialogue
		can_leave = true

func _on_influence_check(amt: int) -> void:
	in_influence_check = true
	progress_bar.value = progress_bar.max_value
	progress_bar.show()

func _process(delta: float) -> void:
	if not in_influence_check:
		progress_bar.hide()
		return
	
	if progress_bar.value >= 0.0:
		progress_bar.value -= 10.0 * delta
		return
	
	if in_influence_check:
		GameManager.kill_player("You got caught.")

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
	progress_bar.hide()
	in_influence_check = false
	
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
