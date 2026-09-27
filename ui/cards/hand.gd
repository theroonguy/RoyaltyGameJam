extends Control

const CARD_SCENE = preload("uid://ctilnrt1x68ma")
@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer

func _ready() -> void:
	refresh()
	
	GameManager.card_added_to_hand.connect(card_added)
	GameManager.card_removed_from_hand.connect(card_added)

func card_added(_card: Card) -> void:
	refresh()

func refresh() -> void:
	for child in h_box_container.get_children():
		if child is Button:
			child.queue_free()
	
	
	for i in range(len(GameManager.hand)):
		var card = GameManager.hand[i]
		var new_card = CARD_SCENE.instantiate()
		new_card.position.y = -size.y
		new_card.position.x = i * 120.0
		new_card.card = card
		
		h_box_container.add_child(new_card)
		new_card.title.text = card.name
