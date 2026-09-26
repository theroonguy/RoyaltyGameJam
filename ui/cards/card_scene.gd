extends Button

var card: Card

func _ready() -> void:
	pressed.connect(select_card)

func select_card() -> void:
	if not card:
		printerr("No card assigned")
	
	# TODO make selection box
	GameManager.selected_card = card
	print("selected card: " + card.name)
