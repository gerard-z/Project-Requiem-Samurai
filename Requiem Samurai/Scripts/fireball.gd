extends Node2D

onready var A = $Area2D
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")	

var nomiciela = -1

var SPEED = 0

var b=20
var tam=1.5
var time
onready var timer = Global.fpscount


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


func _physics_process(delta):
	position += SPEED * delta * -nomiciela * transform.x

	time = Global.fpscount-timer

	#comienzo
	if time < b:
		scale.x = -1 
		scale.y = 0 

	#crecimiento
	elif time < b*4 and time > b:
		
		#get_parent().get_node("fBall/fireball").position.x = pos.x 
		
		if time > b*2.5:
			scale.x = -tam - 0.5
			#get_parent().get_node("fBall/fireball").scale.x = -tam - 0.5
			scale.y = tam + 0.5
			#get_parent().get_node("fBall/fireball").scale.y = tam + 0.5
		else:
			scale.x = -(tam+0.5) * time/(b*2.5)
			#get_parent().get_node("fBall/fireball").scale.x = -(tam+0.5) * time/(b*2.5)
			scale.y = (tam+0.5) * time/(b*2.5)
			#get_parent().get_node("fBall/fireball").scale.y = (tam+0.5) * time/(b*2.5)
	#disparo
	elif time > b*4:
		scale.x = -3
		#get_parent().get_node("fBall/fireball").scale.x = -3
		scale.y = tam
		#get_parent().get_node("fBall/fireball").scale.y = tam
		SPEED = 100
		Global.FBretornable = 1
	#impacto
	if time > b*9:
		scale.x = -tam

		scale.y = tam

		playback.travel("Impacto")
		
	
	if time > b*9.5:
		Global.fireball = true
		queue_free()
