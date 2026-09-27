extends PanelContainer

@onready var label: Label = %Label

func _ready() -> void:
	GameManager.actions_updated.connect(_on_actions_updated)

func _on_actions_updated():
	refresh()

func refresh():
	label.text = "Day %s\n%s Actions Left" % [4 - GameManager.days_left, GameManager.actions_left]
