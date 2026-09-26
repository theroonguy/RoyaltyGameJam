extends Resource
class_name DialogueChain

@export var dialogue: Array[Dialogue] = []

func run() -> void:
	for d: Dialogue in dialogue:
		d.run()
