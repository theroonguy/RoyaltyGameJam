extends Dialogue
class_name AddSuspicion

@export var suspicion_amount: int = 1

func run(character: Character) -> void:
	character.suspicion += suspicion_amount
