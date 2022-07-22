extends Control

onready var continueBoton = $VBoxContainer/Continue
onready var play = $VBoxContainer/Play
onready var options = $VBoxContainer/Options
onready var exit = $VBoxContainer/Exit
onready var creditos = $VBoxContainer/Creditos

onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")	

func _ready():
	anim_tree.active = true
	playback.start("fondo")
	
	continueBoton.connect("pressed", self, "_on_continue_pressed")
	play.connect("pressed", self, "_on_play_pressed")
	options.connect("pressed", self, "_on_options_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")
	creditos.connect("pressed", self, "_on_credits_pressed")
	play.grab_focus()
	var file = File.new()
	continueBoton.disabled = not file.file_exists("user://save.json")
	
func _on_play_pressed():
	get_tree().change_scene("res://Escenes/Intro.tscn")
	#get_tree().change_scene("res://Escenes/main.tscn")
	
func _on_exit_pressed():
	get_tree().quit()

func _on_options_pressed():
	#get_tree().change_scene("res://Escenes/Test Scenes/TEST LVL.tscn")
	#get_tree().change_scene("res://Escenes/lvl1.tscn")
	get_tree().change_scene("res://Escenes/Bosses Fight/Water Boss.tscn")
	
func _on_credits_pressed():
	get_tree().change_scene("res://Escenes/Niveles/Creditos.tscn")
	
func _on_continue_pressed():
	Global.load_game()
