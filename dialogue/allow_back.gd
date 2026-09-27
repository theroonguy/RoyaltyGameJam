extends Dialogue
class_name AllowBack

@export var screen: GameManager.Screen

func _run(character: Character) -> void:
	GameManager.allow_to_go_back.emit(screen)
