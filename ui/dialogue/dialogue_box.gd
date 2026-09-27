extends PanelContainer

@onready var label: Label = %Text
@onready var texture_rect: TextureRect = $TextureRect

signal finished()

func setup(character: Character) -> void:
	label.text = ""
	texture_rect.texture = character.pic

func write_text(text: String) -> void:
	label.text = ""
	
	for i in text:
		label.text += i
		await get_tree().create_timer(0.01).timeout
	
	finished.emit()
	GameManager.dialogue_finished.emit()
