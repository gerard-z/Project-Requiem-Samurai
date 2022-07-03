extends Node2D

onready var A = $Area2D
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")	

var nomiciela = -1

var SPEED = 100


func _ready():
	A.connect("body_entered", self, "_on_body_entered")
	A.connect("area_entered", self, "_on_area_entered")
	anim_tree.active = true
	playback.start("Idle")
	scale.x = 0
	scale.y = 0

func _on_body_entered(body: Node):
	print("pium")

func _on_area_entered(area: Area2D):
	if area.is_in_group("shield") and 	Global.FBretornable == 1:
		nomiciela = 1
		print("bounce")
		print(nomiciela)

func _physics_process(delta):
	position += SPEED * delta * -nomiciela * transform.x

