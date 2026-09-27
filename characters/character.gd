extends Resource
class_name Character

@export var name: String = ""
#@export var dialogue_chain: DialogueChain
@export var dialogue: Dialogue
@export var pic: CompressedTexture2D

@export var influence: int = 1
var standing: int = 0

# how suspicious this character is of the player
@export var suspicion: int = 0
