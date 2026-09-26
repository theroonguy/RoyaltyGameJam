extends Resource
class_name DialogueChain

@export var dialogue: Array[Dialogue] = []

func run(character: Character, ref: Node) -> void:
	for d: Dialogue in dialogue:
		d.run(character)
		await ref.get_tree().create_timer(0.5).timeout
