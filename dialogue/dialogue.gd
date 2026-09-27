extends Resource
class_name Dialogue

@export var next: Dialogue
var ref: Node

@export var use_finish_signal: bool = false

signal finished

func _run(character: Character) -> void:
	pass

func run(character: Character) -> void:
	_run(character)
	if next:
		if use_finish_signal:
			await finished
			await GameManager.get_tree().create_timer(0.5).timeout
		else:
			await GameManager.get_tree().create_timer(0.5).timeout
		next.run(character)
	finished.emit()
