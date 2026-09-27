extends Control

const CHARACTER_BUTTON = preload("uid://hmtbkg5gav52")

@export var location: GameManager.Screen = GameManager.Screen.MOUNTAIN

func _ready() -> void:
	#refresh()
	
	GameManager.character_killed.connect(_on_character_killed)
	GameManager.screen_changed.connect(_on_screen_changed)

func _on_screen_changed(screen: int) -> void:
	if screen == location:
		show()
	else:
		hide()

func _on_character_killed(character: Character) -> void:
	#refresh()
	for child in get_children():
		if child is CharacterButton:
			if child.character == character:
				child.queue_free()

#func refresh() -> void:
	#for child in get_children():
		#if child is Button:
			#child.queue_free()
	#
	#for character: Character in GameManager.characters:
		#var new_button = CHARACTER_BUTTON.instantiate()
		#new_button.text = character.name
		#new_button.position.x = GameManager.characters.find(character) * 150.0
		#new_button.character = character
		#add_child(new_button)
		#new_button.selected.connect(_on_selected.bind(character))

#func refresh() -> void:
	#for child in get_children():
		#if child is CharacterButton:
			#if GameManager.characters.has()

func _on_selected(character: Character) -> void:
	GameManager.talk_to_character(character)

func _on_go_back_pressed() -> void:
	GameManager.change_screen(GameManager.Screen.MAP)
