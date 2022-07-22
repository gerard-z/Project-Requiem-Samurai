extends KinematicBody2D

onready var hitbox = $CollisionShape2D

onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")

onready var detArea = $pivote/DetectionArea
onready var attack1 = $pivote/attack
onready var attack2 = $pivote/attackFig
onready var pivote = $pivote
onready var sprite = $pivote/Sprite

onready var soulPOS = $pivote/Orb

var soul = preload("res://Escenes/Efectos/OrbeDemonio.tscn")

var GRAVITY = 400
export var gravity_effect = 1000
var ACCELERATION = 200
var SPEED = 100

var hit = false
var dist = 80

#ataque de samurai
var dmg =  10

#vida
var health = 100 setget _set_health
var max_health= 100

var velocity = Vector2()

var _target: Node2D = null

var move = true

var muere = 0

var attack = 0

func _ready():
	detArea.connect("body_entered", self, "_on_body_entered")
	attack1.connect("body_entered", self, "_on_body_attacked")
	attack2.connect("body_entered", self, "_on_body_attackedF")
	
	anim_tree.active = true
	playback.start("idle")
	#pivote.scale.x = -1

func _physics_process(delta):
	if health <= 0:
		muere += 1
		death()
	
	else:
		GRAVITY = gravity_effect*Global.gravitychange
		move_and_slide(velocity, Vector2.UP*Global.gravitychange)
		velocity.y += GRAVITY * delta
		
		var move_input = 0

		if _target != null:
			var distance = _target.global_position - global_position
			if move:
				#if int(abs(distance.x)) > dist:
				move_input = (distance).normalized().x*2
				#else:
				#	move_input = 0
			
			if distance.x > 0:
				pivote.scale.x = 1
			
			elif distance.x < 0:
				pivote.scale.x = -1
				
			# mov horizontal
			velocity.x = move_toward(velocity.x, move_input*SPEED, ACCELERATION)
			
			if is_on_floor():
				if int(abs(distance.x)) <= dist:
					attack() 


func attack():
	if attack < 2:
		move = false
		playback.travel("attack")
		yield(get_tree().create_timer(2.0), "timeout")		
		move = true
		attack += 1
	else:
		move = false
		playback.travel("attack fig")
		yield(get_tree().create_timer(2.0), "timeout")		
		move = true
		attack = 0
		#yield(get_tree().create_timer(3.0), "timeout")
			

static func _delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()		


func _set_health(value):
	health= clamp(value, 0,max_health)


func take_damage(dmg,body=null):	
	print("Earth Boss")
	print(health," ",health-dmg)
	
	if Global.ataqpyro > 0: ##condiciòn para superar escudo
		self.health -= dmg
		move = false
		playback.travel("hit")
		yield(get_tree().create_timer(0.7), "timeout")
		move = true
		playback.travel("idle")

func death():
	move = false
	if muere == 1:
		playback.travel("death")
		yield(get_tree().create_timer(3.0), "timeout")
		hitbox.disabled = true
		#sprite.visible = false
		var orbe = soul.instance()
		get_parent().add_child(orbe)
		orbe.global_position = soulPOS.global_position
	else:
		playback.travel("dead")
	
	#######

func _on_body_entered(body : Node):
	_target = body

# daño por combos
func _on_body_attacked(body : Node):
	if body.has_method("take_damage"):
		body.take_damage(10,self)

func _on_body_attackedF(body : Node):
	if body.has_method("take_damage"):
		body.take_damage(20,self)

#choque corporal
func _on_DoDamagePlayer_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(5,self)
