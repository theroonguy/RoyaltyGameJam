extends Button

var card: Card

@onready var influence: Label = $Influence

func _ready() -> void:
	pressed.connect(select_card)
	
	for character in GameManager.characters:
		if character.name == card.name:
			influence.text = str(character.influence)

func select_card() -> void:
	if not card:
		printerr("No card assigned")
	
	# TODO make selection box
	GameManager.selected_card = card
	print("selected card: " + card.name)
