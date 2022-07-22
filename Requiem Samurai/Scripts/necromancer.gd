extends KinematicBody2D

onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")
onready var sprite = $pivote/Sprite
onready var pivote = $pivote
onready var rays = $rays
onready var spawn_fire = $pivote/spawn_batifire
onready var timer = $shootCooldown

var batifire = preload("res://Escenes/Efectos/necrofire.tscn")
var shield = preload("res://Escenes/Efectos/BloodShield.tscn")

var ACCELERATION = 200
var SPEED = 100
var SPEEDUP = 100

var velocity = Vector2()

#ataque
var dmg =  10

#vida
export var max_health= 120
var health = max_health setget _set_health

#IA
var target: Node2D = null
var moveToRight = true
export var altura = 70
export var distanceToPlayer = 12
export var attacking = false
export var canmove = true
export var shilding = false
export var distanceAttack = false
var COOLDOWN = false
var dangerShield = null

export var spawnleft = false

var stuneado = 0 #stun
var stuneadot1= 0
var stuneadot2= 0

func _ready():
	anim_tree.active = true
	playback.start("idle")
	if spawnleft == true:
		pivote.scale.x = -1
		moveToRight = false
	for ray in rays.get_children():
		ray.cast_to.y = altura

	
func _physics_process(delta):
	if health <= 0:
		death()
		
	if stuneado==2:
		stuneadot1=Global.fpscount
		stuneadot2=Global.fpscount
		stuneado=1
		
	elif stuneado==1: 
		print("stuneado")
		anim_tree.active = false
		sprite.modulate = Color(0.65, 0.2, 0.2, 1)
		stuneadot2=Global.fpscount
		if stuneadot2-stuneadot1>=50*1:
			anim_tree.active = true
			stuneado=0
			sprite.modulate = Color.white
		return 1
	else:
		movimiento(delta)
		if target != null and target.global_position.distance_to(global_position) > 1000:
			target = null
		if dangerShield != null:
			dangerShield.global_position = global_position + Vector2(10, -10)

func _process(delta):
	animacion()

### movimiento IA
func movimiento(delta):
	pivote.scale.y = Global.gravitychange
	#chequear colisiones con raycast
	var closest_collision = null
	rays.rotation += delta * 11 * PI
	for ray in rays.get_children():
		if ray.is_colliding():
			var collision_point = ray.get_collision_point() - global_position
			if closest_collision == null:
				closest_collision = collision_point
			if collision_point.length() < closest_collision.length():
				closest_collision = collision_point
	#esquivar
	if closest_collision:
		var normal = -closest_collision.normalized()
		var dodge_direction = 1
		if randf() < 0.5:
			dodge_direction = -1
		velocity += normal * SPEED * 2 * delta
		velocity += normal.rotated(PI/2 * dodge_direction) * SPEED * delta
	
	clamp_velocity()
	move_and_slide(velocity, Vector2.UP*Global.gravitychange)
	#si no tiene target, patrulla
	detect_around(delta)
	if attacking and not canmove and shilding:
		velocity.x = 0
	canmove = true
		
func detect_around(delta):
	#con target hace un seguimiento
	if target != null:
		# distancia a player
		var distance_to_player = global_position.distance_to(target.global_position)
		var distance = target.global_position - global_position
		var vector_to_player = (distance).normalized()
		
		if distance.x > 3:
			pivote.scale.x = 1
		elif distance.x < -3:
			pivote.scale.x = -1
		if distanceAttack:
			if not COOLDOWN:
				shoot()
			if distance_to_player > distanceToPlayer+200:
				# Move towards player
				velocity += vector_to_player * SPEED * delta
			else:
				pass
				# Move away from player
#				velocity += -vector_to_player * SPEED * delta
		else:
			if distance_to_player > distanceToPlayer:
				# Move towards player
				velocity += vector_to_player * SPEED * delta
			else:
				# Move away from player
				velocity += -vector_to_player * SPEED * delta

	else:
		canmove = false


func _set_health(value):
	health= clamp(value, 0,max_health)


func take_damage(dmg,body=null):
	
	print("necromancer")
	print(health,"->",health-dmg)
	self.health -= dmg
	if attacking:
		sprite.modulate = Color.blue
	else:
		getHit()
	yield(get_tree().create_timer(0.1),"timeout")
	sprite.modulate = Color.white

func NotAgarrable():
	pass


#Animación
func animacion():
	if attacking:
		playback.travel("attack3")
	elif velocity.length()>2:
		playback.travel("flight")
	else:
		playback.travel("idle")

func death():
	playback.travel("death")
	
func getHit():
	playback.travel("take_hit")

func _on_detectingArea_body_entered(body: Node2D):
	target = body


func _on_areaAttack_body_entered(body):
	if not shilding and dangerShield == null:
		attacking = true

func clamp_velocity():
	if velocity.length() > SPEEDUP:
		velocity = velocity.normalized() * SPEEDUP


func _on_contactDamage_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(5,self)
	
func spawn_batifire():
	var fire = batifire.instance()
	get_parent().add_child(fire)
	fire.global_position = spawn_fire.global_position
	fire.rotation = Vector2(1,0).angle_to(target.global_position- spawn_fire.global_position)

func shoot():
	COOLDOWN = true
	attacking = true
	timer.start()
	playback.travel("attack2")

func shieldAttack():
	dangerShield = shield.instance()
	get_parent().add_child(dangerShield)
	dangerShield.global_position = global_position + Vector2(10, -10)
	dangerShield.rotation = 52
	dangerShield.scale = Vector2(2,2)
	yield(get_tree().create_timer(1.4), "timeout")
	dangerShield.free()
	dangerShield = null

func _on_shootCooldown_timeout():
	COOLDOWN = false
