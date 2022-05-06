extends KinematicBody2D

export var SPEED = 500
export var ACCELERATION = 700
export var GRAVITY = 3000
export var DIR = 1
var up_down = 1
var hasAttacked = false

var velocity = Vector2()

onready var pivote = $Pivot
onready var sprite = $Pivot/Sprite
onready var hitbox = $Hitbox
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")	
onready var meleArea = $Pivot/"Mele Colision"

onready var baseSprite = $Pivot/Sprite
onready var AirSprite = $Pivot/SpriteAttackBasic
onready var NodeSprite = $Pivot/Node2D
onready var camera = $Camera2D

var fire = false
	
func _ready(): # cuando inicia el juego
	anim_tree.active = true
	playback.start("idle")
	meleArea.connect("body_entered", self, "_on_body_entered")

	
func _physics_process(delta): # por frame
	
	# mecánica innovadora
	if Global.attack > 0:
		NodeSprite.visible = true
		AirSprite.visible = false
		fire = true
	
	else:
		NodeSprite.visible = false
		AirSprite.visible = true	
		fire = false
	
# TODO
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var move_input = Input.get_axis("move_left", "move_right")
	
	# movimiento horizontal
	#velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION)
	velocity.x = move_input * SPEED

	up_down = 1
	
	# gravedad
	velocity.y += GRAVITY * delta * DIR
	
# PISO
	if is_on_floor() and not is_on_wall():
		# salto
		if Input.is_action_just_pressed("jump"):
			velocity.y = -2 * SPEED
		
	
# MURO
	elif is_on_wall() and not is_on_floor():

		#	#		#velocity.y = GRAVITY * 0.25

		if Input.is_action_pressed("move_up") and not Input.is_action_just_pressed("move_down"):
			velocity.y = 0
			up_down = 0


		elif Input.is_action_pressed("move_down") and not Input.is_action_just_pressed("move_up"):
			up_down = 300
		elif velocity.y >0:
			up_down = 25
		
		velocity.y = up_down



		# wall dash
		var fwall = 0
		if Input.is_action_just_pressed("jump"):
			up_down = 1
			if pivote.scale.x<0:
				fwall = 800
			else:
				fwall = -800			
			velocity.x = velocity.x + fwall
			velocity.y = -2 * SPEED
			

# TODO
	var dash = 20000
	var dirdash = 1
	# voltear player al cambiar de dirección
	if Input.is_action_pressed("move_right") and not Input.is_action_just_pressed("move_left"):
		pivote.scale.x = 1
	
	if Input.is_action_pressed("move_left") and not Input.is_action_just_pressed("move_right"):
		pivote.scale.x = -1
	
	hasAttacked = false
	# ataque 1 + dash
	if Input.is_action_just_pressed("attack1") and not is_on_wall():
		velocity.y = 0
		if pivote.scale.x < 0:
			dirdash = -abs(dirdash)
		else:
			dirdash = abs(dirdash)
		hasAttacked = true
		
		
	
# ANIMACIONES	

# Animaciones
	if hasAttacked:
		playback.travel("attack 1")
		velocity.x =  dash * dirdash #dash
		if fire == true:
			Global.attack -= 1

	else:
		if is_on_wall():
			playback.travel("idle wall")
			if velocity.y > 100:
				playback.travel("fall wall")
		
		elif is_on_floor():
			if abs(velocity.x) > 1:
				playback.travel("run")
			else:
				playback.travel("idle")
				
		else:
		# animacion caida y salto
			if velocity.y > 0:
				playback.travel("fall")
			if velocity.y < -0:
				playback.travel("jump")

	
func _on_body_entered(body: Node2D):
	body.take_damage(self)


