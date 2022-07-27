extends Node2D

onready var A = $Area2D
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")	

var SPEED = 400


func _ready():
	anim_tree.active = true
	playback.start("Idle")

func _physics_process(delta):
	position += SPEED * delta * transform.x


func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(5,self)
	playback.travel("Impacto")
	SPEED = 0
