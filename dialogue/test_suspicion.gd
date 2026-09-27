extends Dialogue
class_name TestSuspicion

@export var suspicion_threshold: int = 1
@export var success: Dialogue
@export var failure: Dialogue

func run(character: Character) -> void:
	if character.suspicion >= suspicion_threshold:
		failure.run(character)
	else:
		success.run(character)
