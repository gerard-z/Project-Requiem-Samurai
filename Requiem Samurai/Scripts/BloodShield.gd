extends Node2D

onready var A = $ShieldArea
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")	

var _target: Node2D = null

func _ready():
	anim_tree.active = true
	playback.start("shield")
	A.connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body : Node):
	if body.has_method("take_damage"):
		body.take_damage(5,self)
	
