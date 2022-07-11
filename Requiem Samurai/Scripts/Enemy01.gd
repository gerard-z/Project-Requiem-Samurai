extends KinematicBody2D

onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")

onready var detArea = $pivote/DetectionArea
onready var Sword = $pivote/Sword
onready var pivote = $pivote
onready var sprite = $pivote/Sprite
onready var posPoint = $pivote/FireBall
onready var shield = $pivote/Shield/ShieldArea
onready var posE1 = get_parent().get_node("EnemyPos").global_position
onready var fosaPos = get_parent().get_node("Fosa").global_position

var FB = preload("res://Escenes/Efectos/fireball.tscn")

var GRAVITY = 400
export var gravity_effect = 1000
var ACCELERATION = 200
var SPEED = 70

var hit = false
var dist = 300

#vida
var health = 100 setget _set_health
var max_health= 100

var velocity = Vector2()

var _target: Node2D = null

func _ready():
	detArea.connect("body_entered", self, "_on_body_entered")
	
	Sword.connect("body_entered", self, "_on_body_attacked")
	
	anim_tree.active = true
	playback.start("idle")
	
	shield.connect("area_entered", self, "_on_fireball_entered")
	
	Global.fireball = true
	

func _physics_process(delta):
	GRAVITY = gravity_effect*Global.gravitychange
	move_and_slide(velocity, Vector2.UP*Global.gravitychange)
	
	if is_on_floor():
		velocity.y=0
	velocity.y += GRAVITY * delta
	
	if not is_on_floor():
		Global.FBretornable = 0
		playback.travel("Jump")
	
	var move_input = 0

	if _target != null:
		var distance = _target.global_position - global_position
		var distanceToPos = posE1 - global_position	

		if int(abs(distance.x)) > dist :
			move_input = (distance).normalized().x
		
		elif int(abs(distance.x)) < dist*3/4 and int(abs(distance.x)) > 80:
			move_input = (distanceToPos).normalized().x
			
		elif int(abs(distanceToPos.x)) == 0:
			move_input = 0
	
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
		velocity.y = -8 * SPEED * Global.gravitychange

func attack():
	if Global.FBretornable == 1:
		playback.travel("attack")
	#jump hacia atrás
		
func fireBall():
	if Global.fireball:
		Global.FBretornable = 0
		var FB1 = FB.instance()
		get_parent().add_child(FB1)
		FB1.global_position = posPoint.global_position
		if pivote.scale.x == -1:
			FB1.rotation = PI
		Global.fireball = false
			
static func _delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()		

func _set_health(value):
	health= clamp(value, 0,max_health)


func take_damage(dmg,body=null):	
	print("Boss 1")
	print(health," ",health-dmg)
	
	self.health -= dmg

func _on_body_entered(body : Node):
	_target = body

# daño por espada
func _on_body_attacked(body : Node):
	if body.has_method("take_damage"):
		body.take_damage(30,self)

#choque corporal
func _on_DoDamagePlayer_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(5,self)
	if not is_on_floor():
		print("a la fosa wacho")
		fosa()
		
func fosa():
	var toFall = abs(fosaPos.x - global_position.x)
	Global.inFosa = true
	playback.travel("Jump")
	_target.global_position.x = _target.global_position.x + toFall
	global_position.x = global_position.x + toFall
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene("res://Escenes/lvl1.tscn") #POR AHORA
