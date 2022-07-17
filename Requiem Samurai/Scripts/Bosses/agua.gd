extends KinematicBody2D

onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")

onready var detArea = $pivote/DetectionArea
onready var Sword = $pivote/sword
onready var pivote = $pivote
onready var sprite = $pivote/Sprite
onready var posPoint = $pivote/pium

var blast = preload("res://Escenes/Efectos/waterblast.tscn")

var GRAVITY = 400
export var gravity_effect = 1000
var ACCELERATION = 200
var SPEED = 100

var hit = false
var dist = 80

#vida
var health = 100 setget _set_health
var max_health= 100

var velocity = Vector2()

var _target: Node2D = null

var pium = false

func _ready():
	detArea.connect("body_entered", self, "_on_body_entered")
	
	Sword.connect("body_entered", self, "_on_body_attacked")
	
	anim_tree.active = true
	playback.start("idle")
	pivote.scale.x = -1

func _physics_process(delta):
	GRAVITY = gravity_effect*Global.gravitychange
	move_and_slide(velocity, Vector2.UP*Global.gravitychange)

	velocity.y += GRAVITY * delta
	
	var move_input = 0

	if _target != null:
		var distance = _target.global_position - global_position
		if int(abs(distance.x)) > dist*2:
			move_input = (distance).normalized().x * 2
		
		elif int(abs(distance.x)) > dist :
			move_input = (distance).normalized().x
		
		else:
			move_input = 0
		if distance.x > 0:
			pivote.scale.x = 1
		elif distance.x < 0:
			pivote.scale.x = -1
			
		# mov horizontal
		velocity.x = move_toward(velocity.x, move_input*SPEED, ACCELERATION)
		#print(velocity.x)
		
		if is_on_floor():
			if velocity.x == 0:
				playback.travel("idle")
				if not pium: 
					wBlast()
			
			elif abs(velocity.x) > 190:
				playback.travel("surf") 
			
			else:
				playback.travel("attack") 


func attack():
	playback.travel("attack")
	#jump hacia atrás
		
func wBlast():
	pium = true
	playback.travel("supersoaker")
	var wb1 = blast.instance()
	get_parent().add_child(wb1)
	wb1.global_position = posPoint.global_position
	if pivote.scale.x == 1:
		wb1.scale.x = -1
	yield(get_tree().create_timer(3.0), "timeout")
	pium = false

			
static func _delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()		

func _set_health(value):
	health= clamp(value, 0,max_health)


func take_damage(dmg,body=null):	
	print("Water Boss")
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
