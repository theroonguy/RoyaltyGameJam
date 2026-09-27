@tool
extends TextureRect

@export var time_of_day: GameManager.DayCycle:
	set(new_val):
		time_of_day = new_val
		
		_on_time_changed(time_of_day)

@export var day_grad: GradientTexture2D
@export var night_grad: GradientTexture2D

func _ready() -> void:
	GameManager.time_changed.connect(_on_time_changed)

func _on_time_changed(time: GameManager.DayCycle) -> void:
	var tween = create_tween()
	match time:
		GameManager.DayCycle.DAY:
			tween.tween_property(self, "texture", day_grad, 1.0)
		GameManager.DayCycle.NIGHT:
			tween.tween_property(self, "texture", night_grad, 1.0)
