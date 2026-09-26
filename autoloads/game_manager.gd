## GAME MANAGER
extends Node

# suspicion meter -- 0 to 1, 1 being fully suspicious
var suspicion: float = 0.0

# character relationships dict
var relationships: Dictionary = {}

# list of ALL characters and cards
var characters: Array[Character] = []
var cards: Array[Card] = []

# my hand
var hand: Array[Card] = []

func _ready() -> void:
	#characters = get_all_resources_in_folder("/characters")
	#cards
	process_mode = Node.PROCESS_MODE_ALWAYS # even if tree is paused, keep processing the pause overlay input 
	
	


func form_relationships() -> void:
	for char in characters:
		# TODO: connect all characters
		pass

########## UTILITY ##########

func get_all_resources_in_folder(folder_path: String) -> Array:
	var resources: Array[Resource] = []
	var dir := DirAccess.open(folder_path)
	
	# Loop through all files in the directory
	for file_name in dir.get_files():
		# Optional: Filter out .remap or .import files created during export
		if file_name.ends_with(".import") or file_name.ends_with(".remap"):
			continue
			
		var full_path := folder_path.path_join(file_name)
		var res := load(full_path)
		
		if res:
			resources.append(res)
			
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
