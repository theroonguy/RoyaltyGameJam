extends PanelContainer

@onready var label: Label = %Label
@onready var textss: Label = %Text

func _ready() -> void:
	GameManager.player_died.connect(_on_player_died)

func _on_player_died(text: String) -> void:
	print("dddddddddddd")
	textss.text = text
