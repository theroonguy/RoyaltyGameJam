class_name Hand 
extends ColorRect

const CARD = preload("res://ui/cards/temp_card_scene.tscn")

@export var hand_curve: Curve
@export var rotation_curve: Curve 

@export var max_rotation_degrees := 5
@export var x_sep := -10 
@export var y_min := 0 
@export var y_max := -15

func draw() -> void: 
	print("draw a card")
	var new_card = CARD.instantiate() 
	new_card.text = "Card %s" % (get_child_count() + 1)
	add_child(new_card)
	_update_cards()
	
func discard() -> void: 
	print("discard a card")
	# safety check first tho
	if get_child_count() < 1: 
		return # if there's no cards to discard then... u know, u cant discard. so we just return from the function 
		
	var child := get_child(-1) # otherwise we just grab teh alst child & store it in a variable
	child.reparent(get_tree().root) #reparent it to be the root node of the scene tree
	# ^ gotta reparent it so that when we call it, we know fs that teh cadr wont be a child of hte hand anymore 
	child.queue_free() # and then immediately delete it
	# ^ btw this only deletes when it's safe to do so so thatsw why we're using it 
	_update_cards() # redistribute remaining cards 

func _update_cards() -> void: 
	print("updating cards")


## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
