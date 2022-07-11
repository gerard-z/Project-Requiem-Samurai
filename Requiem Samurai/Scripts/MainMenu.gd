extends MarginContainer


onready var play = $VBoxContainer/Play
onready var options = $VBoxContainer/Options
onready var exit = $VBoxContainer/Exit

onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")	

func _ready():
	anim_tree.active = true
	playback.start("fondo")
	
	play.connect("pressed", self, "_on_play_pressed")
	options.connect("pressed", self, "_on_options_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")
	
func _on_play_pressed():
	get_tree().change_scene("res://Escenes/Intro.tscn")
	#get_tree().change_scene("res://Escenes/main.tscn")
	
func _on_exit_pressed():
	get_tree().quit()

func _on_options_pressed():
	get_tree().change_scene("res://Escenes/Test Scenes/TEST LVL.tscn")
