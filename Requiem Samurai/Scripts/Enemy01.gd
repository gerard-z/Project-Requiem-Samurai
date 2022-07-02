extends KinematicBody2D

onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")

onready var detArea = $DetectionArea
onready var pivote = $pivote

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

var _target: Node2D = null


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

	
		if abs(velocity.x) > 1:
			playback.travel("walk")
		else:
			playback.travel("idle")
			fireBall()

		
		if abs(_target.global_position.x - global_position.x) < dist/5 and abs(_target.global_position.x - global_position.x) > 0:
			attack()


func attack():
	playback.travel("attack")
	#jump hacia atrás
		
func fireBall():
	pass	

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
