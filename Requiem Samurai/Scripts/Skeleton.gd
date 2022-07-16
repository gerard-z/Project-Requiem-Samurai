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
var SPEED = 50

var time1 = 0
var time2 = 0

var velocity = Vector2()

#ataque
var dmg =  10

#vida
var health = 50 setget _set_health
var max_health= 50

#IA
var target: Node2D = null #distancia del área: 226
var moveToRight = true
export var attacking = false
export var canmove = true
export var shilding = false

func _ready():
	anim_tree.active = true
	playback.start("idle")

	
func _physics_process(delta):
	if health == 0:
		death()
	else:
		movimiento()
		animacion()
		if target != null and target.global_position.distance_to(global_position) > 400:
			target = null


func _process(delta):
	pass

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
		if (not rayCastFloor.is_colliding() or rayCastWall.is_colliding()) and is_on_floor():
			canmove = false
	else:
		if (not rayCastFloor.is_colliding() or rayCastWall.is_colliding()) and is_on_floor():
			canmove = true
			moveToRight = not moveToRight
			pivote.scale.x *= -1


func _set_health(value):
	health= clamp(value, 0,max_health)


func take_damage(dmg,body=null):
	
	print("esqueleto")
	print(health,"->",health-dmg)
	canmove = false
	shilding = true
	attacking = false
	
	if Global.ataqpyro > 0: ##condiciòn para superar escudo
		self.health -= dmg
		getHit()
	else:

		escudo()

#para hacerle daño al samurai

func _on_body_entered(body : Node):
	if body.has_method("take_damage"):
		body.take_damage(5)


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

func death():
	playback.travel("death")

func escudo():
	playback.travel("shield")
	
func getHit():
	playback.travel("take_hit")

func _on_detectingArea_body_entered(body: Node2D):
	target = body


func _on_detectMelee_body_entered(body):
	if not shilding:
		attacking = true
