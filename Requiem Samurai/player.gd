extends KinematicBody2D

onready var playback = $AnimationTree.get("parameters/playback")	
	
func _ready(): # cuando inicia el juego
	$AnimationTree.active = true
	playback.start("idle")
	
func _physics_process(delta): # por frame
	pass
