extends KinematicBody2D

var SPEED = 250
var ACCELERATION = 700
var GRAVITY = 3000

var velocity = Vector2()

onready var pivote = $Pivot
onready var sprite = $Pivot/Sprite
onready var collisionshape2D = $CollisionShape2D
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")	
onready var meleArea = $Pivot/"Mele Colision"
	
func _ready(): # cuando inicia el juego
	anim_tree.active = true
	playback.start("idle")
	meleArea.connect("body_entered", self, "_on_body_entered")

	
func _physics_process(delta): # por frame
	
# TODO
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var move_input = Input.get_axis("move_left", "move_right")
	
	# movimiento horizontal
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION)
	
	# gravedad
	velocity.y += GRAVITY * delta



	
# PISO
	if is_on_floor():
		# salto
		if Input.is_action_just_pressed("jump"):
			velocity.y = -4 * SPEED
			
	
		# Animaciones
		if abs(velocity.x) > 10:
			playback.travel("run")
		else:
			if is_on_wall():
				playback.travel("idle wall")
			else:
				playback.travel("idle")
		
	
# MURO
	var move_vertical = Input.get_axis("move_up", "move_down")
	var up_down = 0

	if is_on_wall():
		velocity.y = SPEED * 0.15
		
		if Input.is_action_pressed("move_up") and not Input.is_action_just_pressed("move_down"):
			velocity.y = 0
			
			
		if Input.is_action_pressed("move_down") and not Input.is_action_just_pressed("move_up"):
			up_down = 20
			velocity.y = velocity.y * (1.2 + up_down)

		
		# wall dash
		var fwall = 0
		if Input.is_action_just_pressed("jump"):
			if pivote.scale.x<0:
				fwall = 800
			else:
				fwall = -800			
			velocity.x = velocity.x + fwall
			velocity.y = -4 * SPEED
		
		
		else:
			if is_on_wall():
				playback.travel("idle wall")
			else:
				playback.travel("idle")
			
		


# TODO
	var dash = 10
	# voltear player al cambiar de dirección
	if Input.is_action_pressed("move_right") and not Input.is_action_just_pressed("move_left"):
		pivote.scale.x = 1
	
	if Input.is_action_pressed("move_left") and not Input.is_action_just_pressed("move_right"):
		pivote.scale.x = -1
	
	# ataque 1
	if Input.is_action_just_pressed("attack1") and not is_on_wall():
		if pivote.scale.x<0:
			dash = -23
		else:
			dash = 23
		
		playback.travel("attack 1")
		velocity.y = velocity.y - 500
		velocity.x = velocity.x +  dash * SPEED
	
	# animacion caida y salto
	if velocity.y > 365:
		if is_on_wall():
			playback.travel("fall wall")
		else:
			playback.travel("fall")
	if velocity.y < -365 and not Input.is_action_just_pressed("attack1"):
		playback.travel("jump")

	
func _on_body_entered(body: Node2D):
	body.take_damage(self)


