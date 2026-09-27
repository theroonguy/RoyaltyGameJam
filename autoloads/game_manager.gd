## GAME MANAGER
extends Node

# SCREEN - clarifies which screen is shown out of map, characters and dialogue
enum Screen {
	MAP,
	DIALOGUE,
	MOUNTAIN,
	PALACE,
	COURT,
	WALLS,
}
var current_screen: Screen = Screen.MAP
var last_location: Screen

# suspicion meter -- 0 to 1, 1 being fully suspicious
var suspicion: float = 0.0

# character relationships dict
var relationships: Dictionary = {}

# list of ALL characters and cards
var characters: Array[Character] = []
var cards: Array[Card] = []

# my hand
var hand: Array[Card] = []
var selected_card: Card = null:
	set(new_card):
		selected_card = new_card
		
		card_selected.emit(new_card)

signal character_killed(character: Character)
signal card_played_on_character(card: Card, character: Character)

signal card_selected(card: Card)
signal card_added_to_hand(card: Card)
signal card_removed_from_hand(card: Card)

signal screen_changed(screen: Screen)

signal dialogue_written(text: String, character: Character)
signal dialogue_split(text1: String, option1: Dialogue, text2: String, option2: Dialogue, character: Character)
signal interacted_with_character(character: Character)

func _ready() -> void:
	var char_resources = get_all_resources_under("characters")
	for res in char_resources:
		if res is Character:
			characters.append(res)
	
	var card_resources = get_all_resources_under("cards")
	for res in card_resources:
		if res is Card:
			cards.append(res)
	
	add_card_to_hand(preload("res://cards/poison.tres"))
	
	form_relationships()

	process_mode = Node.PROCESS_MODE_ALWAYS # even if tree is paused, keep processing the pause overlay input 

func form_relationships() -> void:
	for my_char in characters:
		relationships[my_char] = {}
		# for every character, evaluate relationship with every other character
		for other_char in characters:
			
			# don't evaluate against self
			if other_char == my_char:
				continue
			
			relationships[my_char][other_char] = randf_range(0.0, 1.0)
	

func add_card_to_hand(card: Card) -> void:
	hand.append(card)
	card_added_to_hand.emit(card)
	print("card added to hand: " + card.name)

func use_card_on_character(card: Card, character: Character) -> void:
	selected_card = null
	print(card.name + " used on character: " + character.name)
	
	GameManager.card_played_on_character.emit(card, character)
	
	match card.name:
		"Poison":
			kill_character(character)
	
	hand.erase(card)
	card_removed_from_hand.emit(card)

func kill_character(character: Character) -> void:
	characters.erase(character)
	print("Character " + character.name + " has been killed!")
	character_killed.emit(character)

func write_dialogue(text: String, character: Character) -> void:
	dialogue_written.emit(text, character)

func split_dialogue(text1: String, option1: Dialogue, text2: String, option2: Dialogue, character: Character) -> void:
	dialogue_split.emit(text1, option1, text2, option2, character)

func change_screen(screen: Screen) -> void:
	current_screen = screen
	screen_changed.emit(screen)

func talk_to_character(character: Character) -> void:
	last_location = current_screen
	interacted_with_character.emit(character)

########## UTILITY ##########

## Recursively finds and loads resources from a given directory path.
## [param path] The directory to search (e.g., "res://assets/items/")
## [param type_filter] Optional built-in or custom class name to filter by (e.g., "Texture2D" or "ItemData")
func get_all_resources_under(path: String, type_filter: String = "") -> Array[Resource]:
	var resources: Array[Resource] = []
	
	# Open the directory
	var dir = DirAccess.open(path)
	if not dir:
		push_error("Failed to open directory: " + path)
		return resources

	# Start reading contents
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if dir.current_is_dir():
			# Ignore self and parent navigation links
			if file_name != "." and file_name != "..":
				# Recursively explore subfolders
				var subfolder_path = path.path_join(file_name)
				resources.append_array(get_all_resources_under(subfolder_path, type_filter))
		else:
			# Handle export engine behavior (.remap and .import files)
			var original_file_name = file_name
			if original_file_name.ends_with(".remap"):
				original_file_name = original_file_name.trim_suffix(".remap")
			elif original_file_name.ends_with(".import"):
				original_file_name = original_file_name.trim_suffix(".import")
			
			# Filter out actual .import setting files to avoid double processing
			if file_name.ends_with(".import") and not original_file_name.ends_with(".tres") and not original_file_name.ends_with(".res"):
				# If it's a raw asset (like PNG/WAV), keeping the clean suffix allows load() to work
				pass 

			var file_path = path.path_join(original_file_name)
			
			# Load the resource if it hasn't been added yet
			if ResourceLoader.exists(file_path):
				var res = ResourceLoader.load(file_path)
				if res:
					# Check if a type filter was specified and matches
					if type_filter == "" or res.is_class(type_filter) or res.get_script() and res.get_script().get_instance_base_type() == type_filter:
						# Extra check if filtering by a custom class name
						if type_filter == "" or res.is_class(type_filter) or (res.get_class() == "Resource" and res.get_script() and type_filter in str(res.get_script().get_path())):
							if not resources.has(res):
								resources.append(res)

		file_name = dir.get_next()
		
	dir.list_dir_end()
	return resources


# - - - - - stuff regarding pausing and main menu stuffs 
signal game_paused 
signal game_resumed 

const main_menu_scene := "res://ui/main_menu.tscn"
const gameplay_scene := "res://scenes/main_map.tscn"

var pause_overlay_scene: PackedScene = preload("res://ui/pause_overlay.tscn")
var _pause_overlay_instance: CanvasLayer = null 
var _is_paused: bool = false # defualt state 
var current_scene_path: String = gameplay_scene

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): # by  default ui_cancel is the escape key 
		_toggle_pause_overlay() 
		get_viewport().set_input_as_handled() 
	
func _toggle_pause_overlay() -> void: 
	if get_tree().current_scene and get_tree().current_scene.scene_file_path == main_menu_scene: # make sure the pause overlay isn't on top of hte main menu itself 
		return 
	
	if _is_paused: 
		_close_pause_overlay()
	else: 
		_open_pause_overlay()
		
func _open_pause_overlay() -> void: 
	if _pause_overlay_instance != null: 
		return
		
	_pause_overlay_instance = pause_overlay_scene.instantiate() # instantiate teh pause overlya scene into any one 
	get_tree().root.add_child(_pause_overlay_instance)
	
	_is_paused = true 
	get_tree().paused = true 
	emit_signal("game_paused")

func _close_pause_overlay() -> void: 
	if _pause_overlay_instance != null: 
		_pause_overlay_instance.queue_free() # get rid of the pause overlay instance once close button is hit 
		_pause_overlay_instance = null 
	_is_paused = false
	get_tree().paused = false
	emit_signal("game_resumed")
	
func resume_game() -> void: 
	_close_pause_overlay()

func restart_game() -> void:
	_close_pause_overlay()
	get_tree().paused = false
	get_tree().change_scene_to_file(current_scene_path) # gotta define whatever hte current gameplay scene is and change the scene back to it since this allows u to simply reload the current scene 
	
func back_to_main_menu() -> void: 
	_close_pause_overlay() 
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu_scene)
	
func start_new_game() -> void: # at the main menu when u hit play, this runs 
	get_tree().paused = false 
	get_tree().change_scene_to_file(current_scene_path)
	
func set_current_scene_path(path: String) -> void: 
	current_scene_path = path 
	
func quit_game() -> void: 
	get_tree().quit() 
