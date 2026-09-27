extends Dialogue
class_name Text

@export_multiline() var text: String = ""

func _run(character: Character) -> void:
	use_finish_signal = true
	GameManager.write_dialogue(text, character)
	await GameManager.dialogue_finished
	finished.emit()
