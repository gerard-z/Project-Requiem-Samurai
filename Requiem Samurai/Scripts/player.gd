extends KinematicBody2D

export var SPEED = 83
export var ACCELERATION = 233
export var gravity_effect = 1000
export var DIR = 1

export var rebote=800/(3)
var GRAVITY=gravity_effect

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





#ataque basico
var dmg =  1
var time1at = 0
var time2at = 0
var puedeatacar = 1


#vida
var health = 100 setget _set_health
var max_health= 100
onready var progress_bar = $CanvasLayer/ProgressBar


#stamina
var stamina = 100 setget _set_stamina
var max_stamina= 100
onready var progress_bar2 = $CanvasLayer/ProgressBar2


#CD for the regenerations of HP and Stamina 
#stamina
var time1 = 0
var time2 = 0
#hp
var time1h = 0
var time2h = 0

#CD of dash!
var youcandothedash= 0
var cd_time1_stamina = 0
var cd_time2_stamina = 0

var dash = 600
var dashsentido = 1

#doble salto
var maxjumps=1
var jump=0


var agarre=0
var dirdash = 1
		
var fire = false
	
	
	
func _ready(): # cuando inicia el juego
	anim_tree.active = true
	playback.start("idle")
	
	meleArea.connect("body_entered", self, "_on_body_entered")



	
func _health_recharge():
	time2h = OS.get_unix_time()
	var time_elapsed2 = time2h- time1h
	if time_elapsed2 >= 4 and health<100:
		take_damage(-5)

func _stamina_recharge():
	time2 = OS.get_unix_time()
	var time_elapsed = time2- time1
	if time_elapsed >= 2 and stamina<100:
		take_stamina(-10)
		time1 = OS.get_unix_time()
	
func _attack_recharge():
	time2at = OS.get_system_time_msecs()
	var time_elapsed = time2at- time1at
	if time_elapsed >= 800:
		puedeatacar=1
		time1at = OS.get_system_time_msecs()
	


func _physics_process(delta): # por frame
	

	_attack_recharge()
	_stamina_recharge()
	_health_recharge()
	
	# mecánica innovadora
	
	#pyroattack
	if Global.ataqpyro+1 > 0:
		dmg=30
		NodeSprite.visible = true
		AirSprite.visible = false
		fire = true
	
	if Global.ataqpyro+1==0:
		dmg=1
		NodeSprite.visible = false
		AirSprite.visible = true	
		fire = false


	#mecanica gravedad 
	GRAVITY = gravity_effect*Global.gravitychange
	scale.y= Global.gravitychange





	#mecanica rectangulo
	if Global.daishi == -1 and not agarre:
		pivote.scale.x = pivote.scale.x*Global.daishi


		


		
#Time for the Dash:
	cd_time2_stamina=OS.get_system_time_msecs()
	if cd_time2_stamina-cd_time1_stamina>600:
		youcandothedash=0

	
# TODO
	velocity = move_and_slide(velocity, Vector2.UP*Global.gravitychange)
	
	var move_input = Input.get_axis("move_left", "move_right")
	
	# movimiento horizontal
	#velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION)
	if is_on_floor():
		velocity.x = move_input * SPEED
	else:
		velocity.x  = move_toward(velocity.x, move_input * SPEED, 12)
	up_down = 1
	
	# gravedad
	velocity.y += GRAVITY * delta * DIR
	
	
# PISO
	if is_on_floor() and not is_on_wall():

		jump=0
		# salto
		if Input.is_action_just_pressed("jump"):
			velocity.y = -4 * SPEED *Global.gravitychange

	
# MURO

	elif is_on_wall() and not is_on_floor() and agarre:
		youcandothedash=0
		jump=0


		if Input.is_action_pressed("move_up") and not Input.is_action_just_pressed("move_down"):
			velocity.y = 0
			up_down = 0

		elif Input.is_action_pressed("move_down") and not Input.is_action_just_pressed("move_up"):
			up_down = 300
		elif velocity.y >0:
			up_down = 25
		
		velocity.y = up_down



		# wall jump
		var fwall = 0
		if Input.is_action_just_pressed("jump"):
			up_down = 1
			if pivote.scale.x<0:
				fwall = 150
			else:
				fwall = -150			
			velocity.x =  fwall
			velocity.y = -4 * SPEED
			

# movimiento

	# voltear player al cambiar de dirección
	if Input.is_action_pressed("move_right") and not Input.is_action_just_pressed("move_left"):
		dashsentido=1
		if Global.daishi==1:
			pivote.scale.x = 1
	
	if Input.is_action_pressed("move_left") and not Input.is_action_just_pressed("move_right"):
		dashsentido=-1
		if Global.daishi==1:
			pivote.scale.x = -1
	
	
	hasAttacked = false
	# ataque 1 
	if Input.is_action_just_pressed("attack1") and not is_on_wall() and puedeatacar==1:
		hasAttacked = true
		puedeatacar=0
	
	
	
	#sprint 
	if Input.is_action_pressed("sprint") and is_on_floor() and stamina>0 and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		cd_time1_stamina = OS.get_system_time_msecs()
		if pivote.scale.x < 0:
			dirdash = -abs(dirdash)
		else:
			dirdash = abs(dirdash)
			
		velocity.x =   velocity.x*2.5
		time1 = OS.get_unix_time()
		take_stamina(0.3)		
	
	
	
	#dash
	if Input.is_action_just_pressed("dash"):			
		if stamina>=20 and youcandothedash==0:
			youcandothedash=1
			cd_time1_stamina = OS.get_system_time_msecs()
			if pivote.scale.x < 0:
				dirdash = -abs(dirdash)
			else:
				dirdash = abs(dirdash)
				
			if Global.daishi==-1:
				dirdash=dashsentido

			
			velocity.y = 0
			time1 = OS.get_unix_time()
			take_stamina(20)	

	if cd_time2_stamina-cd_time1_stamina<100 and youcandothedash==1:
		velocity.x =  dash * dirdash #dash
		velocity.y=0
	
	if cd_time2_stamina-cd_time1_stamina<120 and 100<cd_time2_stamina-cd_time1_stamina and youcandothedash==1:
		velocity.x= (dash/2)*dirdash



	#doble salto
	if Input.is_action_just_pressed("jump") and not is_on_wall() and not is_on_floor() and maxjumps>jump:
		jump+=1
		velocity.x = 300*move_input + abs(velocity.x)*move_input #dash
		velocity.y = -4 * SPEED * Global.gravitychange



	
# ANIMACIONES	

# Animaciones
	if hasAttacked:
		playback.travel("attack 1")
		if fire == true:
			Global.ataqpyro -= 1

			


	else:
		if is_on_wall() and agarre:
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




func _set_health(value):
	health= clamp(value, 0,max_health)
	progress_bar.value = health


func _set_stamina(value):
	stamina=clamp(value, 0,max_stamina)
	progress_bar2.value = stamina

func take_stamina(value):
	self.stamina -= value



func take_damage(value,body=null):
	print("samurai")
	print(health," " ,health-value)
	self.health -= value
	time1h = OS.get_unix_time()
	
	#para simular un golpe
	if value>0:
		velocity = -global_position.direction_to(body.global_position) * rebote
		
		if velocity.y>0:
			velocity.y*=-1




#para hacerle daño
func _on_body_entered(body: Node2D):
	body.take_damage(dmg)




func _on_AgarreWall_body_entered(body):

	agarre=body.is_in_group("agarrables")





func _on_AgarreWall_body_exited(body):
	
	agarre=false
#
	#else:
	#	print(agarre)
	#	agarre=0
