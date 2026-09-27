extends Dialogue
class_name DialogueSplit

@export var text1: String
@export var option1: Dialogue
@export var text2: String
@export var option2: Dialogue

func _run(character: Character) -> void:
	GameManager.split_dialogue(text1, option1, text2, option2, character)
	
