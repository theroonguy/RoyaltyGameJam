extends Button

var character: Character

@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	pressed.connect(select_character)
	
	setup_button()

func setup_button():
	if not character:
		printerr("no character selected")
		return false
	
	if character.pic:
		texture_rect.texture = character.pic
		texture_rect.size = Vector2(100,100)
	
	size = Vector2(150,150)

func select_character() -> bool:
	if not character:
		printerr("no character selected!")
		return false
	
	if GameManager.selected_card:
		# if card selected, use it on character
		GameManager.use_card_on_character(GameManager.selected_card, character)
		return true
	
	if character.dialogue_chain:
		# if just selecting the character, open dialogue (for now)
		character.dialogue_chain.run()
		return true
	
	printerr("no action available")
	
	return true
