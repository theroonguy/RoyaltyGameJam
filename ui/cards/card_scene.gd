extends Button

var card: Card

@onready var influence: Label = $Influence
@onready var title: Label = $Title

var highlighted

var counter: float

func _ready() -> void:
	pressed.connect(select_card)
	
	for character in GameManager.characters:
		if character.name == card.name:
			influence.text = str(character.influence)
	
	GameManager.influence_check.connect(_on_influence_check)

func _on_influence_check(needed: int) -> void:
	if int(influence.text) >= needed:
		highlighted = true

func _process(delta: float) -> void:
	if not highlighted:
		return
	
	counter += delta
	modulate.g = remap(sin(counter), -1.0, 1.0, 1.0, 1.5)

func select_card() -> void:
	if not card:
		printerr("No card assigned")
	
	# TODO make selection box
	GameManager.selected_card = card
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
	print("selected card: " + card.name)
	
	var result = await GameManager.card_played_on_character
	var past_pos = global_position
	top_level = true
	await get_tree().process_frame
	global_position = past_pos
	tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(200, 200), 0.5)
	await tween.finished
	
	GameManager.card_animation_finished.emit()

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
