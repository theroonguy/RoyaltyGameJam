extends Button

@export var dialogue: Dialogue

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	dialogue.run(null)
	hide()
