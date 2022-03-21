extends KinematicBody2D

var SPEED = 250
var ACCELERATION = 500
var GRAVITY = 3000

var velocity = Vector2()


onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")	
	
func _ready(): # cuando inicia el juego
	anim_tree.active = true
	playback.start("idle")
	
func _physics_process(delta): # por frame
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var move_input = Input.get_axis("move_left", "move_right")
	
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION)
	
	velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -4 * SPEED
	
	# Animation
	
	# si no está saltando/en el aire
	if is_on_floor():
		if abs(velocity.x) > 10:
			playback.travel("run")
		else:
			playback.travel("idle")
	
	# cuando está saltando/en el aire
	else:
		pass
		#if velocity.y > 0:
		#	playback.travel("fall")
		#else:
		#	playback.travel("jump")
	
	# ataque 1
	if Input.is_action_just_pressed("attack1"):
		playback.travel("attack 1")
	
	# voltear player al cambiar de dirección
	if Input.is_action_pressed("move_right") and not Input.is_action_just_pressed("move_left"):
		sprite.flip_h = false
	if Input.is_action_pressed("move_left") and not Input.is_action_just_pressed("move_right"):
		sprite.flip_h = true
