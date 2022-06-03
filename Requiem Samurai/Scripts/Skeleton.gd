extends KinematicBody2D

onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")
onready var sprite = $Sprite


var GRAVITY = 400
var ACCELERATION = 200
var SPEED = 50
var hit = false
var time1 = 0
var time2 = 0

var velocity = Vector2()

#ataque
var dmg =  10

#vida
var health = 100 setget _set_health
var max_health= 100


func _ready():
	anim_tree.active = true
	playback.start("idle")

	
func _physics_process(delta):
	
	#gravity power
	if Global.gravitychange==-1:
		GRAVITY = -400
	if Global.gravitychange==1:
		GRAVITY = 400


	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.y += GRAVITY * delta
	velocity.x = 0


func _process(delta):

	if hit:
		time2 = OS.get_unix_time()	
		var time_elapsed = time2- time1
		sprite.modulate = Color(sin(time_elapsed*50+1), cos(time_elapsed*50+2), sin(time_elapsed*50) , 1)
		if (time_elapsed>3):
			hit = false
	else:
		sprite.modulate = Color(1, 1, 1, 1)
	
	#############################################
	# solo para la demo
	if health == 0:
		self.visible = false
		$Hitbox.disabled=true
		$DoDamage/CollisionShape2D.disabled=true
		GRAVITY = 0
		
		yield(get_tree().create_timer(5), "timeout")
		
		$Hitbox.disabled=false
		$DoDamage/CollisionShape2D.disabled=false
		GRAVITY = 400
		self.visible = true
		
		health = 100
	############################################


	
func _set_health(value):
	health= clamp(value, 0,max_health)


func take_damage(dmg,body=null):
	
	print("esqueleto")
	print(health," ",health-dmg)
	
	if Global.ataqpyro > 0:
		self.health -= dmg
		hit = true
		time1 = OS.get_unix_time()

		


#para hacerle daño al samurai

func _on_body_entered(body : Node):
	if body.has_method("take_damage"):
		body.take_damage(5)


var buglequitavidaalesqueleto = 0

func _on_DoDamage_body_entered(body):
	if buglequitavidaalesqueleto==0:
		buglequitavidaalesqueleto=1
	elif body.has_method("take_damage"):
		body.take_damage(5,self)



func NotAgarrable():
	pass
