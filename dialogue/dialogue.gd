extends Resource
class_name Dialogue

@export var next: Dialogue
var ref: Node

func _run(character: Character) -> void:
	pass

func run(character: Character) -> void:
	_run(character)
	if next:
		await GameManager.get_tree().create_timer(0.5).timeout
		next.run(character)
		
