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
var selected_card: Card = null:
	set(new_card):
		selected_card = new_card
		
		card_selected.emit(new_card)

signal card_selected(card: Card)
signal card_added_to_hand(card: Card)
signal card_removed_from_hand(card: Card)

func _ready() -> void:
	var char_resources = get_all_resources_under("characters")
	for res in char_resources:
		if res is Character:
			characters.append(res)
	
	var card_resources = get_all_resources_under("cards")
	for res in card_resources:
		if res is Card:
			cards.append(res)
	
	form_relationships()

func form_relationships() -> void:
	for my_char in characters:
		print(my_char)
		relationships[my_char] = {}
		# for every character, evaluate relationship with every other character
		for other_char in characters:
			
			# don't evaluate against self
			if other_char == my_char:
				continue
			
			relationships[my_char][other_char] = randf_range(0.0, 1.0)
	
	print(relationships)

func add_card_to_hand(card: Card) -> void:
	hand.append(card)
	card_added_to_hand.emit(card)
	print("card added to hand: " + card.name)
	print(hand)

func use_card_on_character(card: Card, character: Character) -> void:
	# TODO: base on character what will happen based on card
	selected_card = null
	print(card.name + " used on character: " + character.name)
	pass

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
