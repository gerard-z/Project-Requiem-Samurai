extends KinematicBody2D

onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")

onready var detArea = $DetectionArea
onready var pivote = $pivote
onready var sprite = $pivote/Sprite
onready var posPoint = $FireBall
onready var shield = $pivote/Shield/ShieldArea

var FB = preload("res://Escenes/Efectos/fireball.tscn")

var GRAVITY = 400
export var gravity_effect = 1000
var ACCELERATION = 200
var SPEED = 70

var hit = false
var dist = 400

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
	
	shield.connect("area_entered", self, "_on_fireball_entered")
	
	

func _physics_process(delta):
	GRAVITY = gravity_effect*Global.gravitychange

	
	move_and_slide(velocity, Vector2.UP*Global.gravitychange)
	
	if is_on_floor():
		velocity.y=0
	velocity.y += GRAVITY * delta
	
	if not is_on_floor():
		playback.travel("Jump")
	
	var move_input = 0
	
	
	if _target != null:
		var distance = _target.global_position - global_position
		if int(abs(distance.x)) > dist :
			move_input = (distance).normalized().x
		
#		elif int(abs(_target.global_position.x - global_position.x)) == dist:
#			move_input = 0	
		else:
			move_input = 0
	
		if distance.x > 0:
			pivote.scale.x = -1
		
		elif distance.x < 0:
			pivote.scale.x = 1
			
	
		# mov horizontal
		velocity.x = move_toward(velocity.x, move_input*SPEED, ACCELERATION)

		if is_on_floor():
			if abs(velocity.x) > 1:
				playback.travel("walk")
			else:
				playback.travel("idle")
				fireBall()

		
		if abs(distance.x) < 80 and distance.x != 0:
			attack()

func _on_fireball_entered(area):
	jump()

func jump():
	if Global.FBretornable == 1:
		velocity.y = -8 * SPEED *Global.gravitychange
		Global.E1jump = 0

func attack():
	if canAttack == 1:
		playback.travel("attack")
	#jump hacia atrás
		
func fireBall():
	if Global.fireball:
		Global.fireball = false
		canAttack = 0
		Global.FBretornable = 0
		var FB1 = FB.instance()
		get_parent().add_child(FB1)
		FB1.global_position = posPoint.global_position
		if pivote.scale.x == -1:
			FB1.rotation = PI
			
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
	self.health -= dmg
	#	hit = true
	#	time1 = Global.fpscount





func _on_body_entered(body : Node):
	_target = body





func _on_DoDamagePlayer_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(5,self)
