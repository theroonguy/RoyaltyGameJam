#class_name HandManager
#extends ColorRect
#
#const CARD = preload("res://ui/cards/card_scene.tscn")
#
#@export var hand_curve: Curve
#@export var rotation_curve: Curve 
#
#@export var max_rotation_degrees := 5
#@export var x_sep := -10 
#@export var y_min := 0 
#@export var y_max := -15
#
#func draw() -> void: 
	#print("draw a card")
	#var new_card = CARD.instantiate() 
	#new_card.text = "Card %s" % (get_child_count() + 1)
	#add_child(new_card)
	#_update_cards()
	#
#func discard() -> void: 
	#print("discard a card")
	## safety check first tho
	#if get_child_count() < 1: 
		#return # if there's no cards to discard then... u know, u cant discard. so we just return from the function 
		#
	#var child := get_child(-1) # otherwise we just grab teh alst child & store it in a variable
	#child.reparent(get_tree().root) #reparent it to be the root node of the scene tree
	## ^ gotta reparent it so that when we call it, we know fs that teh cadr wont be a child of hte hand anymore 
	#child.queue_free() # and then immediately delete it
	## ^ btw this only deletes when it's safe to do so so thatsw why we're using it 
	#_update_cards() # redistribute remaining cards 
#
#func _update_cards() -> void: 
	#var cards := get_child_count()
	#var all_cards_size := TempCard.SIZE.x * cards + x_sep * (cards - 1) # could be TempCard or Card i forgot ngl 
	#print("updating cards")
	#
	#var final_x_sep := x_sep # this and below are basically just the math required to get the cards to overlap at a required amount yk
	#
	#if all_cards_size > size.x: 
		#final_x_sep = (size.x - TempCard.SIZE.x * cards) / (cards - 1)
		#all_cards_size = size.x
	#
	#var offset := (size.x - all_cards_size) / 2
	#
	#for i in cards: 
		#var card := get_child(i)
		#var y_multiplier := hand_curve.sample(1.0 / (cards - 1) * i) 
		#var rot_multiplier := rotation_curve.sample(1.0 / (cards - 1) * i)
		#
		#if cards == 1: # if we only have 1 card then like... we can't really divide by zero huh
			#y_multiplier = 0.0
			#rot_multiplier = 0.0 
			#
		## set final posoition of all the cards once ur done with all the boring maths of finding what to divide and whateversz
		#var final_x: float = offset + TempCard.SIZE.x * i + final_x_sep * i 
		#var final_y: float = y_min + y_max * y_multiplier 
		#
		#card.position = Vector2(final_x, final_y)
		#card.rotation_degrees = max_rotation_degrees * rot_multiplier 
#
#
## ---------------- asdfuhasoufhadsfoahsdf this is copied over from temp_hand
#@onready var deck_hand: HandManager = $"."
#
#
#func _on_draw_card_pressed() -> void:
	#deck_hand.draw()
#
#
#func _on_reset_card_pressed() -> void:
	#get_tree().reload_current_scene()
#
#
#func _on_discard_card_pressed() -> void:
	#deck_hand.discard()
