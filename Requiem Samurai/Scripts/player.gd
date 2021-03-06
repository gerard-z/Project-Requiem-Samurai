extends KinematicBody2D

export var SPEED = 325 # 83 -> 400
export var SPEEDY = 200
export var ACCELERATION = 700 # 233 -> 700
export var gravity_effect = 3000 #1000 -> 3000
export var DIR = 1
export var AERIAL_COEFICIENT = -3 # Reduccion altura del salto -4 -> -3 #no está en la versión development
export var rebote = 1000
export(NodePath) var spawPointFinal = null
var GRAVITY=gravity_effect

var dirTraz = Vector2(0,0)

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

onready var flecha = $PivoteFlecha/pos2

#movement
var res_air_move = 5
var jump_air_y = 5

#ataque basico
var dmg =  1
var time1at = 0
var time2at = 0
var puedeatacar = 1
var fix_atq_pyro = 1


var golpefps = 100

#vida
var health setget _set_health
var max_health= 100
onready var progress_bar = $CanvasLayer/ProgressBar



#stamina
var stamina setget _set_stamina
var max_stamina= 100
onready var progress_bar2 = $CanvasLayer/ProgressBar2

#CD for the regenerations of HP and Stamina 
#stamina
var time1
var time2
#hp
var time1h
var time2h

####################################################################################################
# TRAZADO
var timeTrz0 = 0
var traz = true
####################################################################################################


#CD of dash!
var youcandothedash= 0
var cd_time1_stamina = 0
var cd_time2_stamina = 0

var cd_time1_dash= 0
var cd_time2_dash = 0

var dash = 1000
var dashsentido = 1
var dirdash = 1



#doble salto
var maxjumps=1
var jump=0



var agarre=0

var fire = false
	
#pa q no explote en locura saltando
var usoelmarcarpuntos = 0
	
func _ready(): # cuando inicia el juego
	anim_tree.active = true
	playback.start("idle")
	_set_health(Global.health)
	_set_stamina(Global.stamina)
	
	time1 = Global.fpscount
	time2 = Global.fpscount

	time1h = Global.fpscount
	time2h = Global.fpscount
	
	meleArea.connect("body_entered", self, "_on_body_entered")
	if Global.spawnFinal:
		spawPointFinal = get_node(spawPointFinal)
		global_position = spawPointFinal.global_position



	
func _health_recharge():
	time2h = Global.fpscount
	var time_elapsed2 = time2h- time1h

	if time_elapsed2 >= 60*8 and health<100:
		take_damage(-5)

func _stamina_recharge():
	time2 = Global.fpscount
	var time_elapsed = time2- time1
	if time_elapsed >= 40*2 and stamina<100:
		take_stamina(-10)
		time1 = Global.fpscount
	
func _attack_recharge():
	time2at = Global.fpscount
	var time_elapsed = time2at- time1at
	if time_elapsed >=24:
		puedeatacar=1
		
	


func _physics_process(delta): # por frame
	velocity = move_and_slide(velocity, Vector2.UP * Global.gravitychange)		
	var move_input = Input.get_axis("move_left", "move_right")
	
	#Animation fosa
	if Global.inFosa or Global.deathBoss:
		velocity.y += GRAVITY * delta * DIR
		velocity.x = 0
		fall_jump()
		if.is_on_floor():
			playback.travel("death")
			yield(get_tree().create_timer(3.0), "timeout")
			Global.revive = true
			Global.seactivaeltrazado = true
			Global.inFosa = false
			
			
	
	
	else:
		
		_attack_recharge()
		_stamina_recharge()
		_health_recharge()
	
		mecInnovadora()
		if health > 0:
			
			# movimiento horizontal
			golpefps+=1
			
			if golpefps<5:
				velocity.x  = move_toward(velocity.x, move_input * SPEED, res_air_move)
			else:
				velocity.x = move_input * SPEED 
			up_down = 1
			
			# gravedad
			velocity.y += GRAVITY * delta * DIR
			
			
		# PISO
			if is_on_floor() and not is_on_wall():

				jump=0
				# salto
				if Input.is_action_just_pressed("jump"):
					velocity.y = -jump_air_y * SPEEDY *Global.gravitychange
			
		# MURO

			#agarrado
			elif is_on_wall() and not is_on_floor() and agarre:
				youcandothedash=0
				jump=0
				wall()
					
		#Movimiento
			# voltear player al cambiar de dirección
			if Input.is_action_pressed("move_right") and not Input.is_action_just_pressed("move_left"):
				dashsentido=1
				if Global.daishi==1:
					pivote.scale.x = 1
			
			if Input.is_action_pressed("move_left") and not Input.is_action_just_pressed("move_right"):
				dashsentido=-1
				if Global.daishi==1:
					pivote.scale.x = -1
			
			Global.dir = dashsentido
			
			
			#ataques
			hasAttacked = false ################# cambiar
			# ataque 1 
			if Input.is_action_just_pressed("attack1") and puedeatacar==1 and not is_on_wall():
				hasAttacked = true
				puedeatacar=0
				time1at = Global.fpscount
			animations()
			


		####################################################################################################
			
			if Global.conteopuntos>4:
				usoelmarcarpuntos=1
			if Global.conteopuntos<=4 and is_on_floor():
				usoelmarcarpuntos=0

			
			# NEW TRAZADO
			if Global.seactivaeltrazado and usoelmarcarpuntos!=1:
				#var move = Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down")
				
				
				if Input.is_action_just_pressed("vertice"):
					dirTraz = Vector2(0,0)
					timeTrz0 = Global.fpscount
					traz = true
					flecha.position.x = 0
					flecha.position.y = 41
					flecha.rotation_degrees = 90
				
				
				
				if Input.is_action_pressed("vertice") and traz:
					var dt = (Global.fpscount - timeTrz0)/30
					velocity.x = 0
					velocity.y = 0
					
					if Input.is_action_just_pressed("move_left"):
						dirTraz.x = -1
					if Input.is_action_just_pressed("move_right"):
						dirTraz.x = 1
					if Input.is_action_just_pressed("move_up"):
						dirTraz.y = -1
					if Input.is_action_just_pressed("move_down"):
						dirTraz.y = 1
						
					#var grados = rad2deg(acos(dirTraz.x)) * dirTraz.y
					#print(grados)
						
					# puse esto porque no me pescó grados = rad2deg(acos(dirTraz.x)) * dirTraz.y				
					if dirTraz != Vector2(0,0):
						flecha.position.x = dirTraz.x * 41
						flecha.position.y = dirTraz.y * 41
					
						if dirTraz == Vector2(1,0):
							flecha.rotation_degrees = 0
						if dirTraz == Vector2(1,1):
							flecha.rotation_degrees = 45
						if dirTraz == Vector2(0,1):
							flecha.rotation_degrees = 90
						if dirTraz == Vector2(-1,1):
							flecha.rotation_degrees = 135
						if dirTraz == Vector2(-1,0):
							flecha.rotation_degrees = 180
						if dirTraz == Vector2(-1,-1):
							flecha.rotation_degrees = 225
						if dirTraz == Vector2(0,-1):
							flecha.rotation_degrees = 270
						if dirTraz == Vector2(1,-1):
							flecha.rotation_degrees = 315
					
					else:
						flecha.position.x = 0
						flecha.position.y = 41
						flecha.rotation_degrees = 90
					
					if dt>0.92:				
						#direccion
						timeTrz0 = Global.fpscount						
						dirTraz = dirTraz.normalized()

						traz = false
						
				var dt = Global.fpscount - timeTrz0

				en_dashTR(dirTraz,dt)

		####################################################################################################	
			
			#Time for the Dash:
			cd_time2_stamina=Global.fpscount
			cd_time2_dash=Global.fpscount
			if cd_time2_dash-cd_time1_dash>52:
				youcandothedash=0

			sprint(move_input)
			
			#dash
			if Input.is_action_just_pressed("dash") :			
				dash()
			en_dash()
			
			double_jump(move_input)
			
			# Animaciones
			#animations()


####################################################################################################
#
# 											MÉTODOS
#
####################################################################################################

func mecInnovadora():
	#espada de fuego
	
	set_pyro()
	
	set_hydro()

	set_earth()
	
	#if Global.elementalsword == 1 :
	#	NodeSprite.modulate= Color(1,1,1)

	#if Global.elementalsword == 2 :
	#	NodeSprite.modulate= Color(0.04, 0.08,1,1)
	
	#if Global.elementalsword == 3 :
	#	NodeSprite.modulate= Color(0.2,0.8,3)
		
		
	if Global.ataqpyro<=0 and Global.ataqhydro<=0 and Global.ataqearth<=0 :
		dmg =0
		NodeSprite.visible = false
		AirSprite.visible = true	
		fire = false
		Global.elementalsword=0 #estado base

	#mecanica gravedad (cambia la gravedad)
	GRAVITY = gravity_effect*Global.gravitychange
	scale.y= Global.gravitychange
	
	#daishi style
	if Global.daishi == -1 and not agarre:
		pivote.scale.x = pivote.scale.x*Global.daishi




func set_pyro():
	if Global.ataqpyro > 0:
		dmg=35
		NodeSprite.visible = true
		AirSprite.visible = false
		fire = true
	
	if Global.ataqpyro<=0:
		#dmg=1
		pass
		#NodeSprite.visible = false
		#AirSprite.visible = true	
		#fire = false

func set_hydro():
	if Global.ataqhydro > 0:
		dmg=10
		NodeSprite.visible = true
		AirSprite.visible = false
		fire = true
	
	if Global.ataqhydro<=0:

		pass

func set_earth():
	if Global.ataqearth > 0:
		dmg=15
		NodeSprite.visible = true
		AirSprite.visible = false
		fire = true
	
	if Global.ataqhydro<=0:

		pass


func sprint(move_input):
	if golpefps>5 and Input.is_action_pressed("sprint") and is_on_floor() and stamina>0 and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		cd_time1_stamina = Global.fpscount
		if pivote.scale.x < 0:
			dirdash = -abs(dirdash)
		else:
			dirdash = abs(dirdash)
			
		velocity.x =   SPEED*1.5*move_input
		time1 = Global.fpscount
		take_stamina(0.3)		




#animaciones principales
func animations():
	#el ataque
	if hasAttacked and playback.get_current_node() != "attack 1" and playback.get_current_node() != "attack water"  and playback.get_current_node() != "attack earth":
		attack()
	else:
		if playback.get_current_node() != "attack 1" and playback.get_current_node() != "attack water"  and playback.get_current_node() != "attack earth":
			if is_on_wall() and agarre:
				playback.travel("idle wall")
				if velocity.y > 100:
					playback.travel("fall wall")
			
			elif is_on_floor():
				if abs(velocity.x) > 1:
					playback.travel("run")
				elif health != 0:
					playback.travel("idle")
					
			else:
				fall_jump()




# dash
func dash():
	if stamina>=20 and youcandothedash==0:
		youcandothedash=1
		cd_time1_stamina = Global.fpscount
		cd_time1_dash = Global.fpscount
		if pivote.scale.x < 0:
			dirdash = -abs(dirdash)
		else:
			dirdash = abs(dirdash)
			
		if Global.daishi==-1:
			dirdash=dashsentido
			
		velocity.y = 0
		time1 = Global.fpscount
		take_stamina(20)	




#en el das
func en_dash():

	#en el dash
	if cd_time2_dash-cd_time1_dash<10 and youcandothedash==1:
		velocity.x =  dash * dirdash #dash
		velocity.y=0
		#aiuda pa implementar una animacion de dash uwu
		#playback.travel("dash")
	#luego de terminarlo
	if cd_time2_dash-cd_time1_dash<11 and 9<cd_time2_dash-cd_time1_dash and youcandothedash==1:
		#playback.travel("dash")
		velocity.x/= 2

func double_jump(move_input):
	#doble salto
	if Input.is_action_just_pressed("jump") and not is_on_wall() and not is_on_floor() and maxjumps>jump:
		jump+=1
		velocity.x = SPEED *move_input + abs(velocity.x)*move_input #dash
		velocity.y = -jump_air_y * SPEEDY * Global.gravitychange #coef del level




func en_dashTR(d, dt):
	#en el dash
	#velocity.y = 0
	if dt < 12:
		velocity= dash *d *0.8 #dash
		playback.travel("dash")
	#luego de terminarlo
	if dt < 12 and 8 < dt:
		playback.travel("dash")
		velocity /= 2




# wall move
func wall():
	#WALLse mantiene
	if (Input.is_action_pressed("move_up") and not Input.is_action_just_pressed("move_down")):
		velocity.y = 0
		up_down = 0
		
	#WALL baja
	elif Input.is_action_pressed("move_down") and not Input.is_action_just_pressed("move_up"):
		up_down = SPEED
	elif velocity.y >0:
		up_down = SPEEDY/3
		
	velocity.y = up_down

	# wall jump
	var fwall = 0
	if Input.is_action_just_pressed("jump"):
		up_down = 1
		if pivote.scale.x<0:
			fwall = SPEEDY/2
		else:
			fwall = -SPEEDY/2			
		velocity.x =  fwall
		velocity.y = -jump_air_y * SPEEDY # level tenia el coeff




### ATAQUE 1
func attack():

	if Global.elementalsword==1:
		playback.travel("attack 1")
		yield(get_tree().create_timer(0.4), "timeout")
		if Global.ataqpyro<=0:
			Global.ataqpyro = 0
		else: 
			Global.ataqpyro -= 1
			print("attackpyro = ", Global.ataqpyro)


	if Global.elementalsword==2:

		playback.travel("attack water")
		yield(get_tree().create_timer(0.4), "timeout")

		if Global.ataqhydro<=0:
			Global.ataqhydro = 0

		else: Global.ataqhydro -= 1

	if Global.elementalsword==3:

		playback.travel("attack earth")
		yield(get_tree().create_timer(0.4), "timeout")

		if Global.ataqearth<=0:
			Global.ataqearth = 0

		else: Global.ataqearth -= 1

	if Global.elementalsword==0:
		playback.travel("attack 1")
		yield(get_tree().create_timer(0.4), "timeout")

# fall y jump animations
func fall_jump():
	var vAir = 400
	if Global.inFosa:
		playback.travel("fall")
	if velocity.y > vAir:
		playback.travel("fall")
	if velocity.y < -vAir:
		playback.travel("jump")



func _set_health(value):
	health= clamp(value, 0,max_health)
	progress_bar.value = health



func _set_stamina(value):
	stamina=clamp(value, 0,max_stamina)
	progress_bar2.value = stamina



func take_stamina(value):
	self.stamina -= value
	Global.stamina = self.stamina



func take_damage(value,body=null):
	print("samurai")
	print(health,"->" ,health-value)
	if golpefps<6:
		return 1
	
	self.health -= value
	time1h = Global.fpscount
	Global.health = health

	#para simular un golpe
	if value>0 and health > 0:
		velocity.y = -jump_air_y * SPEEDY*3/4 * Global.gravitychange
		velocity.x = (-global_position.direction_to(body.global_position) * rebote).x
		golpefps=0
	#muere
	if self.health<=0 and Global.inFosa == false:
		print("Muere")
		Global.save_game(get_tree().current_scene.filename)
		velocity.x = 0
		#velocity.y = 0
		playback.travel("death")
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene("res://Escenes/menus/MainMenu.tscn")
		take_damage(-100)




#para hacerle daño
func _on_body_entered(body: Node2D):

		
	body.take_damage(dmg)
	
	if Global.elementalsword==3:
		
		body.stuneado=2
	
	if Global.elementalsword==2:
		self.take_damage(-20)


#agarres
func _on_AgarreWall_body_entered(body):
	agarre=body.is_in_group("agarrables")


func _on_AgarreWall_body_exited(body):
	agarre=false
