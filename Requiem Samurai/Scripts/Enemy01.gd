extends KinematicBody2D

onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")

onready var detArea = $DetectionArea
onready var pivote = $pivote
onready var sprite = $pivote/Sprite
onready var posPoint = $FireBall

var FB = preload("res://Escenes/Efectos/fireball.tscn")
export var Grid = 50

var GRAVITY = 400
export var gravity_effect = 1000
var ACCELERATION = 200
var SPEED = 70

var hit = false
var time1 = 0
var time2 = 0

#vida
var health = 100 setget _set_health
var max_health= 100

var velocity = Vector2()
var pos = Vector2()

var _target: Node2D = null
var canAttack = 1


func _ready():
	detArea.connect("body_entered", self, "_on_body_entered")
	
	anim_tree.active = true
	playback.start("idle")
	
	
	
	

func _physics_process(delta):
	GRAVITY = gravity_effect*Global.gravitychange

	
	move_and_slide(velocity, Vector2.UP*Global.gravitychange)
	
	if is_on_floor():
		velocity.y=0
	velocity.y += GRAVITY * delta
	
	#JUMP
	if Global.E1jump == 2:
		velocity.y = -8 * SPEED *Global.gravitychange
		Global.E1jump = 0
	
	if is_on_floor() == false:
		playback.travel("Jump")
	
	var move_input = 0
	var dist = 400
	
	if _target != null:
		
		if int(abs(_target.global_position.x - global_position.x)) > dist :
			move_input = (_target.global_position - global_position).normalized().x
		
		elif int(abs(_target.global_position.x - global_position.x)) == dist:
			move_input = 0	
	
		if _target.global_position.x - global_position.x > 0:
			pivote.scale.x = -1
		
		elif _target.global_position.x - global_position.x < 0:
			pivote.scale.x = 1
			
	
		# mov horizontal
		velocity.x = move_toward(velocity.x, move_input*SPEED, ACCELERATION)

		if is_on_floor():
			if abs(velocity.x) > 1:
				playback.travel("walk")
			else:
				playback.travel("idle")
				time2 = Global.fpscount
				fireBall(time2)

		
		if abs(_target.global_position.x - global_position.x) < 80 and abs(_target.global_position.x - global_position.x) > 0:
			attack()


func attack():
	if canAttack == 1:
		playback.travel("attack")
	#jump hacia atrás
		
func fireBall(t2):
	var time = t2 - time1
	var scl = 0
	#print(time)
	
	#if time > 0 and get_parent().get_node("fBall").get_child_count() == 0:
	if time > 0 and get_node("FireBall").get_child_count() == 0:

		canAttack = 0
		
		var FB1 = FB.instance()
		#get_parent().get_node("fBall").add_child(FB1)
		get_node("FireBall").add_child(FB1)
		#get_parent().get_node("fBall").global_position = posPoint.global_position
		#FB1.global_position = posPoint.global_position
		Global.FBretornable = 0
		if pivote.scale.x == -1:
			FB1.rotation = PI
		
	if time > 300:
		time1 = Global.fpscount
	
	else:
		var b = 20
		var tam = 1.5
		if time < b:
			get_node("FireBall/fireball").scale.x = -1 
			#get_parent().get_node("fBall/fireball").scale.x = -1 
			get_node("FireBall/fireball").scale.y = 0 
			#get_parent().get_node("fBall/fireball").scale.y = 0 
		
		elif time == b:
			pos = get_node("FireBall/fireball").position
			#pos = get_parent().get_node("fBall/fireball").position
		
		elif time < b*4 and time > b:
			get_node("FireBall/fireball").position.x = pos.x 
			#get_parent().get_node("fBall/fireball").position.x = pos.x 
			
			if time > b*2.5:
				get_node("FireBall/fireball").scale.x = -tam - 0.5
				#get_parent().get_node("fBall/fireball").scale.x = -tam - 0.5
				get_node("FireBall/fireball").scale.y = tam + 0.5
				#get_parent().get_node("fBall/fireball").scale.y = tam + 0.5
			else:
				get_node("FireBall/fireball").scale.x = -(tam+0.5) * time/(b*2.5)
				#get_parent().get_node("fBall/fireball").scale.x = -(tam+0.5) * time/(b*2.5)
				get_node("FireBall/fireball").scale.y = (tam+0.5) * time/(b*2.5)
				#get_parent().get_node("fBall/fireball").scale.y = (tam+0.5) * time/(b*2.5)
		
		elif time > b*4:
			get_node("FireBall/fireball").scale.x = -3
			#get_parent().get_node("fBall/fireball").scale.x = -3
			get_node("FireBall/fireball").scale.y = tam
			#get_parent().get_node("fBall/fireball").scale.y = tam
			canAttack = 1
			Global.FBretornable = 1
		
		if time > b*7:
			get_node("FireBall/fireball").scale.x = -tam
			#get_parent().get_node("fBall/fireball").scale.x = -tam
			get_node("FireBall/fireball").scale.y = tam
			#get_parent().get_node("fBall/fireball").scale.y = tam
			get_node("FireBall/fireball/AnimationTree").get("parameters/playback").travel("Impacto")
			#get_parent().get_node("fBall/fireball/AnimationTree").get("parameters/playback").travel("Impacto")
			
		
		if time > b*7.5:
			if get_node("FireBall").get_child_count() == 1:
			#if get_parent().get_node("fBall/fireball").get_child_count() == 1:
				#_delete_children(get_parent().get_node("fBall"))
				_delete_children(get_node("FireBall"))
				Global.E1jump = 0
		
		

			
static func _delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()		

func _set_health(value):
	health= clamp(value, 0,max_health)


func take_damage(dmg,body=null):	
	print("Boss 1")
	print(health," ",health-dmg)
	
	#if Global.ataqpyro > 0:
	#	self.health -= dmg
	#	hit = true
	#	time1 = Global.fpscount

		


#para hacerle daño al samurai

func _on_body_entered(body : Node):
	_target = body
	#if body.has_method("take_damage"):
	#	body.take_damage(5)


#var buglequitavida = 0

#func _on_DoDamage_body_entered(body):
#	if buglequitavida==0:
#		buglequitavida=1
#	elif body.has_method("take_damage"):
#		body.take_damage(5,self)



#func NotAgarrable():
#	pass
