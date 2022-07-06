extends Node2D

onready var A = $Area2D
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")	

var nomiciela = -1

var SPEED = 0

var b=20
var tam=2
var time = 0
var impact = 0
onready var timer = Global.fpscount


func _ready():
	A.connect("body_entered", self, "_on_body_entered")
	A.connect("area_entered", self, "_on_area_entered")
	anim_tree.active = true
	playback.start("Idle")
	scale.x = 0
	scale.y = 0

func _on_body_entered(body: Node):
	if Global.FBretornable == 1:
		print("pium")
		if body.has_method("take_damage"):
			body.take_damage(20,self)
		impact = 1
		Global.FBretornable = 0
		destroy()
	

func _on_area_entered(area: Area2D):
	if area.is_in_group("shield") and 	Global.FBretornable == 1:
		nomiciela = 1
		print("bounce")

func _physics_process(delta):
	time = Global.fpscount - timer
	
	if time < b*9 and impact == 0:
		position += SPEED * delta * -nomiciela * transform.x

	#crecimiento
	if time < b*4 and time > b:
		if time > b*2.5:
			scale.x = -tam - 0.5
			scale.y = tam + 0.5
		else:
			scale.x = -(tam + 0.5) * time/(b*2.5)
			scale.y = (tam + 0.5) * time/(b*2.5)
	#disparo
	elif time == b*4:
		Global.FBretornable = 1
	elif time > b*4:
		scale.x = -3
		scale.y = tam
		SPEED = 120
	if time > b*9:
		destroy()

func destroy():
	#impacto
	scale.x = -tam
	scale.y = tam
	playback.travel("Impacto")
	yield(get_tree().create_timer(0.4), "timeout")
	Global.fireball = true
	queue_free()
