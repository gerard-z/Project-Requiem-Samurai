extends KinematicBody2D

onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")
onready var sprite = $pivote/Sprite
onready var rayCastFloor = $pivote/RayCastFloor
onready var rayCastWall = $pivote/RayCastWall
onready var pivote = $pivote


var GRAVITY = 400
export var gravity_effect = 17
var ACCELERATION = 200
var SPEED = 300
var SPEEDUP = 400

var velocity = Vector2()

#ataque
var dmg =  10

#vida
var health = 3 setget _set_health
var max_health= 3

#IA
var target: Node2D = null
var moveToRight = true
export var attacking = false
export var canmove = true
export var shilding = false

export var spawnleft = false

func _ready():
	anim_tree.active = true
	playback.start("idle")
	if spawnleft == true:
		pivote.scale.x = -1
		moveToRight = false

	
func _physics_process(delta):
	if health <= 0:
		death()
	else:
		movimiento()
		if target != null and target.global_position.distance_to(global_position) > 1000:
			target = null


func _process(delta):
	animacion()

### movimiento IA
func movimiento():
	GRAVITY = gravity_effect*Global.gravitychange
	pivote.scale.y = Global.gravitychange

	move_and_slide(velocity, Vector2.UP*Global.gravitychange)
	if is_on_floor():
		velocity.y=0
	velocity.y += GRAVITY
	#si no tiene target, patrulla
	detect_around()
	if not attacking and canmove and not shilding:
		velocity.x = SPEED if moveToRight else -SPEED
	else:
		velocity.x = 0
	canmove = true
		
func detect_around():
	#con target hace un seguimiento
	if target != null:
		var distance = target.global_position.x - global_position.x
		if distance > 10:
			pivote.scale.x = 1
			moveToRight = true
		elif abs(distance) <= 10:
			canmove = false
		else:
			pivote.scale.x = -1
			moveToRight = false
	else:
		canmove = false
	if is_on_floor():
		if rayCastWall.is_colliding():
			if not rayCastFloor.is_colliding():
				velocity.y = -SPEEDUP
			else:
				if target == null:
					canmove = true
					moveToRight = not moveToRight
					pivote.scale.x *= -1
				else:
					canmove = false


func _set_health(value):
	health= clamp(value, 0,max_health)


func take_damage(dmg,body=null):
	
	print("bandido")
	print(health,"->",health-dmg)
	canmove = false
	shilding = true
	attacking = false
	
	self.health -= dmg
	getHit()

#para hacerle daño al samurai
func _on_DoDamage_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(5,self)

func NotAgarrable():
	pass


#Animación
func animacion():
	if is_on_floor() and not shilding:
		if abs(velocity.x)>4:
			playback.travel("walk")
		elif attacking:
			playback.travel("attack")
		else:
			playback.travel("idle")
	elif not is_on_floor():
		if velocity.y<-10:
			playback.travel("jump")
		else:
			playback.travel("fall")

func death():
	playback.travel("death")
	
func getHit():
	playback.travel("take_hit")

func _on_detectingArea_body_entered(body: Node2D):
	target = body


func _on_detectMelee_body_entered(body):
	if not shilding:
		attacking = true
