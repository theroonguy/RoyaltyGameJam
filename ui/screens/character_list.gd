extends Control

const CHARACTER_BUTTON = preload("uid://hmtbkg5gav52")

@export var location: GameManager.Screen = GameManager.Screen.MOUNTAIN
@export var dialogue_on_approach: Dialogue
var dialogue_said: bool = false
@onready var go_back: Button = $GoBack
@export var show_back: bool = true

@export var back: GameManager.Screen = GameManager.Screen.MAP

func _ready() -> void:
	GameManager.character_killed.connect(_on_character_killed)
	GameManager.screen_changed.connect(_on_screen_changed)
	GameManager.allow_to_go_back.connect(_on_allow_to_go_back)
	
	go_back.visible = show_back

func _on_allow_to_go_back(screen: GameManager.Screen) -> void:
	if screen == location:
		go_back.show()

func _on_screen_changed(screen: int) -> void:
	if screen == location:
		show()
		
		if dialogue_on_approach and not dialogue_said:
			dialogue_on_approach.run(null)
			dialogue_said = true
	else:
		hide()

func _on_character_killed(character: Character) -> void:
	for child in get_children():
		if child is CharacterButton:
			if child.character == character:
				child.queue_free()

func _on_selected(character: Character) -> void:
	GameManager.talk_to_character(character)

func _on_go_back_pressed() -> void:
	GameManager.change_screen(back)
