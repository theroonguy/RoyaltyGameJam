extends Dialogue
class_name KillPlayer

@export var text: String = ""

func run(character: Character) -> void:
	print("ASDJOIAJSDOI")
	GameManager.kill_player(text)
