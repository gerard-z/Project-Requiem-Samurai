extends Node2D

onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")	

func _ready():
	anim_tree.active = true
	playback.start("nada")

func _physics_process(delta):
	if Global.revive or Global.deathBoss:
		playback.travel("rayo")
		yield(get_tree().create_timer(1.0), "timeout")
		Global.revive = false
		Global.deathBoss = false
