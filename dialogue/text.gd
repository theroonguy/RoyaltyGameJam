extends Dialogue
class_name Text

@export_multiline() var text: String = ""
@export var from_player: bool = false

func _run(character: Character) -> void:
	use_finish_signal = true
	if from_player:
		character = preload("res://characters/player.tres")
	GameManager.write_dialogue(text, character)
	await GameManager.dialogue_finished
	finished.emit()
