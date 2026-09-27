extends Dialogue
class_name WriteStatus

@export_multiline() var text: String = ""

func _run(character: Character) -> void:
	GameManager.write_status.emit(text)
