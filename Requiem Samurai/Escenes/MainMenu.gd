extends MarginContainer


onready var play = $Panel/VBoxContainer/Play
onready var options = $Panel/VBoxContainer/Options
onready var exit = $Panel/VBoxContainer/Exit

func _ready():
	play.connect("pressed", self, "_on_play_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")
	
func _on_play_pressed():
	get_tree().change_scene("res://Escenes/main.tscn")
	
func _on_exit_pressed():
	get_tree().quit()
