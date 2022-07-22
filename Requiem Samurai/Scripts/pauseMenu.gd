extends MarginContainer

onready var ResumeButton = $PanelContainer/VBoxContainer/Resume
onready var MainMenuButton = $PanelContainer/VBoxContainer/MainMenu
onready var saveGame = $PanelContainer/VBoxContainer/save
onready var loadGame = $PanelContainer/VBoxContainer/load

func _ready():
	ResumeButton.connect("pressed", self, "_on_resume_pressed")
	MainMenuButton.connect("pressed", self, "_on_mainmenu_pressed")
	saveGame.connect("pressed", self, "_on_save_pressed")
	loadGame.connect("pressed", self, "_on_load_pressed")
	visible = false

func _input(event):
	if event.is_action_pressed("Pause") and not event.is_echo():
		get_tree().paused = true
		visible = true
	
func _on_resume_pressed():
	get_tree().paused = false
	visible = false
	
func _on_mainmenu_pressed():
	get_tree().change_scene("res://Escenes/menus/MainMenu.tscn")
	get_tree().paused = false

func _on_save_pressed():
	var ruta = get_tree().current_scene.filename
	get_tree().paused = false
	Global.save_game(ruta)
	get_tree().paused = true

func _on_load_pressed():
	get_tree().paused = false
	Global.load_game()
	visible = false
