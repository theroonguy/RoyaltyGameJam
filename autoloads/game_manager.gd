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
	characters = get_all_resources_in_folder("/characters")
	#cards

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
