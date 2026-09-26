extends Control

const CARD_SCENE = preload("uid://ctilnrt1x68ma")

func _ready() -> void:
	refresh()
	
	GameManager.card_added_to_hand.connect(card_added)
	GameManager.card_removed_from_hand.connect(card_added)

func card_added(_card: Card) -> void:
	refresh()

func refresh() -> void:
	for child in get_children():
		child.queue_free()
	
	for i in range(len(GameManager.hand)):
		var card = GameManager.hand[i]
		var new_card = CARD_SCENE.instantiate()
		new_card.position.x = i * 120.0
		new_card.text = card.name
		new_card.card = card
		
		add_child(new_card)
