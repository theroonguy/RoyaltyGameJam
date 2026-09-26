extends Control

@onready var play_button: TextureButton = $Container/VBoxContainer/PlayButton
@onready var restart_button: TextureButton = $Container/VBoxContainer/RestartButton
@onready var quit_button: TextureButton = $Container/VBoxContainer/QuitButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # menu never ges affectsed by pasued tree
	
	play_button.pressed.connect(_on_play_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	play_button.grab_focus()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	GameManager.start_new_game()


func _on_restart_pressed() -> void:
	GameManager.restart_game()


func _on_quit_pressed() -> void:
	GameManager.quit_game()
