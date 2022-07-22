extends KinematicBody2D

onready var hitbox = $CollisionShape2D

onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")

onready var detArea = $pivote/DetectionArea
onready var attack = $pivote/attack
onready var pivote = $pivote
onready var sprite = $pivote/Sprite

onready var soulPOS = $pivote/Orb

var soul = preload("res://Escenes/Efectos/OrbeDemonio.tscn")

var ACCELERATION = 200
var SPEED = 500
var GRAVITY = 400

var hit = false


#ataque de samurai
var dmg =  10

#vida
var health = 100 setget _set_health
var max_health= 100

var velocity = Vector2()

var _target: Node2D = null

var move = true

var muere = 0

var ataque = 0

var move_input = 0

func _ready():
	detArea.connect("body_entered", self, "_on_body_entered")
	attack.connect("body_entered", self, "_on_body_attacked")
	
	anim_tree.active = true
	playback.start("idle")
	
	pivote.scale.x = -1

func _physics_process(delta):
	if health <= 0:
		muere += 1
		velocity.y += GRAVITY * delta
		death()
		
	
	else:
		move_and_slide(velocity, Vector2.UP*Global.gravitychange)
		

		if _target != null:
			var distance = _target.global_position - global_position
			var dist = 300
			
			if move:
				#límite exterior
				if int(abs(distance.x)) > dist or is_on_wall():
					move_input = (distance).normalized().x 
				
				if int(abs(distance.x)) == 0:
					move_input = -1

				# mov horizontal
				velocity.x = move_toward(velocity.x, move_input*SPEED, ACCELERATION)
				velocity.y = -velocity.x/2
					
			else:
				velocity.x = 0
				velocity.y = 0
			
			if distance.x > 0:
				pivote.scale.x = -1
			elif distance.x < 0:
				pivote.scale.x = 1
				
			
			
			if is_on_floor():
				if abs(velocity.x) == 0 and int(abs(distance.x)) > dist:
					pass
				
				elif int(abs(distance.x)) <= dist:
					attack() 
			
			else:
				playback.travel("idle")

func attack():
	move = false
	playback.travel("attack")	
	yield(get_tree().create_timer(1.1), "timeout")
	move = true



static func _delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()		



func _set_health(value):
	health= clamp(value, 0,max_health)



func take_damage(dmg,body=null):	
	print("Daishi Boss")
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
		
		Global.actualBoss = "daishi"
		
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


