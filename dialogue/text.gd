extends Dialogue
class_name Text

@export_multiline() var text: String = ""

func _run(character: Character) -> void:
	GameManager.write_dialogue(text, character)
