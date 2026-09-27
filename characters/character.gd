extends Resource
class_name Character

@export var name: String = ""
#@export var dialogue_chain: DialogueChain
@export var dialogue: Dialogue
@export var pic: CompressedTexture2D

# how suspicious this character is of the player
var suspicion: float = 0.0
