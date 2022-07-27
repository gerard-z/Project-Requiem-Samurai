extends Node2D

onready var A = $Area2D
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")	

var SPEED = 15

var fire = 0
onready var timer = Global.fpscount


func _ready():
	A.connect("body_entered", self, "_on_body_entered")
	A.connect("area_entered", self, "_on_area_entered")
	
	yield(get_tree().create_timer(0.4), "timeout")
	anim_tree.active = true
	playback.start("make")
	yield(get_tree().create_timer(1.0), "timeout")
	fire = 1

func _physics_process(delta):
	position.x += SPEED * fire * -scale.x

func _on_body_entered(body: Node):
	print("pium")
	if body.has_method("take_damage"):
		body.take_damage(10,self)
	destroy()
	
#defensa
func _on_area_entered(area: Area2D):
	if area.is_in_group("shield"):
		destroy()

func destroy():
	#impacto
	fire = 0
	playback.travel("death")
	yield(get_tree().create_timer(0.6), "timeout")
	queue_free()
