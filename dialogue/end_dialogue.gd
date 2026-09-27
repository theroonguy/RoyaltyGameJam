extends Dialogue
class_name EndDialogue

func run(character: Character) -> void:
	GameManager.end_dialogue.emit()
