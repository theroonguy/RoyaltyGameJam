extends Dialogue
class_name Text

@export_multiline() var text: String = ""

func run(character: Character) -> void:
	# TODO: display to screen
	print(text)
	GameManager.write_dialogue(text, character)
