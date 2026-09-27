class_name TempCard
extends Panel

# var card: Card

const SIZE := Vector2(100, 150)

@export var text: String 
@onready var label: Label = $Label

func _ready() -> void:
	label.text = text 
	# pressed.connect(select_card)
	

#func select_card() -> void:
	#if not card:
		#printerr("No card assigned")
	#
	## TODO make selection box
	#GameManager.selected_card = card
	#print("selected card: " + card.name)
