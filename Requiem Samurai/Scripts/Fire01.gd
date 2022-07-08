extends Node2D

onready var A = $Area2D
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")	

func _ready():
	anim_tree.active = true
	playback.start("fire")
	A.connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body : Node):
	if body.has_method("take_damage"):
		body.take_damage(5,self)
