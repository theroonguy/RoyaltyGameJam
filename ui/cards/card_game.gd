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
		if child is Button:
			child.queue_free()
	
	for i in range(len(GameManager.hand)):
		var card = GameManager.hand[i]
		var new_card = CARD_SCENE.instantiate()
		new_card.position.y = -size.y
		new_card.position.x = i * 120.0
		new_card.text = card.name
		new_card.card = card
		# new_card.setup(card)
		
		add_child(new_card)


# - - - - -lowkey following a tutorial rn trying to figure out how to create a 2d card fanning thingy yk
#
#@onready var hand: HandManager = $DeckHand
#
#func _on_draw_card_pressed() -> void:
	#hand.draw()
#
#
#func _on_reset_card_pressed() -> void:
	#get_tree().reload_current_scene()
#
#
#func _on_discard_card_pressed() -> void:
	#hand.discard()
