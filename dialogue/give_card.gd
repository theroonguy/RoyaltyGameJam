extends Dialogue
class_name GiveCard

@export var card: Card

func run(character: Character) -> void:
	if not card:
		printerr("No card selected")
	
	GameManager.add_card_to_hand(card)
