extends CanvasLayer


@onready var resume_button: TextureButton = $Container/VBoxContainer/ResumeButton
@onready var restart_button: TextureButton = $Container/VBoxContainer/RestartButton
@onready var quit_button: TextureButton = $Container/VBoxContainer/QuitButton
@onready var main_menu_button: TextureButton = $Container/VBoxContainer/MainMenuButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	resume_button.pressed.connect(_on_resume_pressed) # connecting w/ the signals 
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

	resume_button.grab_focus() 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_pressed() -> void:
	GameManager.resume_game() # connect to autoload gamemanager


func _on_restart_pressed() -> void:
	GameManager.restart_game() # yes


func _on_quit_pressed() -> void:
	GameManager.quit_game() 

func _on_main_menu_pressed() -> void:
	GameManager.back_to_main_menu() 
