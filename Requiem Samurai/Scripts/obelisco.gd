extends Node2D

onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")	
onready var A = $Area2D

func _ready():
	A.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node):
	anim_tree.active = true
	playback.start("off")
