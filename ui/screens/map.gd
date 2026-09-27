extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.screen_changed.connect(_on_screen_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_palace_button_pressed() -> void:
	GameManager.change_screen(GameManager.Screen.PALACE) # basically whenever u click a button, the characterlist scene shows up ish in the limits of the screen. that way you can itneract with characters and stuff yk yk yk anyways that's basically what it is for now (timestamp: 6:03 pm on 9/26/2026) 
	# i think soon the different buttons will have a different set of characters in each so this script might be changed soon 


func _on_outer_palace_button_pressed() -> void:
	GameManager.change_screen(GameManager.Screen.COURT)


func _on_walls_button_pressed() -> void:
	GameManager.change_screen(GameManager.Screen.WALLS)


func _on_mountains_button_pressed() -> void:
	GameManager.change_screen(GameManager.Screen.MOUNTAIN)

func _on_screen_changed(screen: int) -> void: # this basically hdies the map whenever a button (e.g. the palace button) is pressed so that the character list and dialogue options are allowed to show up 
	if screen == GameManager.Screen.MAP: 
		show()
	else: 
		hide() 
