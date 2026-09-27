extends Dialogue
class_name InfluenceDialogue

# requires a certain amount of influence to be a success
@export var success: Dialogue
@export var failure: Dialogue
@export var needed_influence: int = 1

func _run(character: Character) -> void:
	var result: Array = await GameManager.card_played_on_character
	var card: Card = result[0]
	var c_result: Character = result[1]
	
	if c_result != character:
		print("failure!")
		failure.run(character)
		return
	
	var applied_influence: int = 0
	for c in GameManager.characters:
		if card.name == c.name:
			applied_influence = c.influence
	
	if applied_influence >= needed_influence:
		success.run(character)
		print("success!")
		return
	
	failure.run(character)
	print("failed!")
