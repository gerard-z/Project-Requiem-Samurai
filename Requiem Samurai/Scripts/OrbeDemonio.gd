extends Node2D

onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")	
onready var A = $Area2D



func _ready():
	A.connect("body_entered", self, "_on_body_entered")
	anim_tree.active = true
	playback.start("make")

func _on_body_entered(body: Node):
	Global.deathBoss = true
	if Global.actualBoss == "daishi": Global.M_daishi = 1
	if Global.actualBoss == "tierra": Global.M_Earth_Sword = 1
	if Global.actualBoss == "agua": Global.M_Water_sword = 1
	if Global.actualBoss == "gravity": Global.M_gravity = 1
		
	Global.actualBoss = ""
	destroy()

func destroy():
	queue_free()
