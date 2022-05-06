extends MarginContainer

onready var ResumeButton = $PanelContainer/VBoxContainer/Resume
onready var OptionsButton = $PanelContainer/VBoxContainer/Options
onready var MainMenuButton = $PanelContainer/VBoxContainer/MainMenu

func _ready():
	ResumeButton.connect("pressed", self, "_on_resume_pressed")
	OptionsButton.connect("pressed", self, "_on_option_pressed")
	MainMenuButton.connect("pressed", self, "_on_mainmenu_pressed")
	visible = false

func _input(event):
	if event.is_action_pressed("Pause") and not event.is_echo():
		get_tree().paused = true
		visible = true
	
func _on_resume_pressed():
	get_tree().paused = false
	visible = false
	
func _on_option_pressed():
	pass
	
func _on_mainmenu_pressed():
	get_tree().change_scene("res://Escenes/MainMenu.tscn")
	get_tree().paused = false
