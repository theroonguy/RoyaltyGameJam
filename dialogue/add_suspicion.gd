extends Dialogue
class_name AddSuspicion

@export var suspicion_amount: int = 1

func _run(character: Character) -> void:
	character.suspicion += suspicion_amount
