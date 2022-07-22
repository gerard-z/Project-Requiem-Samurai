extends Node

#spawn
var spawnFinal = false

var dir = 1

#enemy 01
var FBretornable = 0
var fireball = true
var inFosa = false

var revive = false
var deathBoss = false


#Habiliades Samurai
var figure = 0
var type_figure = 0 #subvariante de la figura
var area = 0
var health = 100
var stamina = 100

var lvlskill = 4 #habilidades desbloqueadas

var elementalsword = 0
var ataqpyro = 0 #1
var ataqhydro= 0 #2
var ataqearth = 0 #3

var gravitychange = 1

#mecánicas desbloqueables
var M_Water_sword = 0
var M_Earth_Sword = 0
var M_daishi = 0
var M_gravity = 0

#bosses
var actualBoss = "" 

var time1 =1
var time2 =1

var time1s =1
var time2s =1

var daishi =1


var conteopuntos=0


var fpscount = 0

var seactivaeltrazado=false

func _process(delta): #tiempo => frames
	area = round(area)

	_gravity_time_power()
	daishi_sword()
	
	if area==0 and figure==1 and lvlskill>=1 and M_Earth_Sword == 1:
			elementalsword=3
			ataqhydro=0
			ataqpyro=0
			
			ataqearth+=3
			if ataqearth>=4:
				ataqearth=4
			print("attack earth = ", ataqearth)
	
	if area != 0:
		print(figure, " ", area)
		
		if figure == 1 and lvlskill>=1:		#triangulo
			
			if type_figure==0: #Pyro Sword
				elementalsword=1
				ataqhydro=0
				ataqearth=0
				
				ataqpyro+=3
				if ataqpyro>=4:
					ataqpyro=4
				print("attackpyro = ", ataqpyro)
		
			elif M_Water_sword == 1: #Hydro_sword
				elementalsword=2
				ataqpyro=0
				ataqearth=0
				ataqhydro =3
				if ataqhydro>=4:
					ataqhydro=4
				print("attackhydro = ", ataqhydro)
				
				#por si agregamos una figura en especifico al viento
	#	if figure == 2 and lvlskill>=2:		# /\/ viento
	#		
	#		#WindSword
	#			elementalsword=3
	#			ataqpyro=0
	#			ataqhydro=0
	#			ataqwind=3
		#		print("attackwind = ", ataqwind)
			
			
		
		if figure ==3 and lvlskill>=3 and M_daishi == 1:   # rectangulo  estilo daishi
			time1s= fpscount
			daishi= -1

			
			
		if figure == 4 and lvlskill>=4 and M_gravity == 1:  #reloj gravity
			time1= fpscount
			gravitychange=-1

func _gravity_time_power():
	time2 = fpscount
	var time_elapsed = time2 - time1
	
	if time_elapsed >= 150:
		gravitychange=1






#utilizar fps para el tiempo #nota para mi yo del futuro planeando

func _physics_process(delta): #cuenta 1 frame
	fpscount+=1


func daishi_sword():
	time2s = fpscount
	var time_elapseds = time2s - time1s
	
	if time_elapseds >= 60*3:
		daishi=1

func save_game(ruta):
	var file = File.new()
	file.open("user://save.json", File.WRITE)
	file.store_string(ruta)
	file.close()
	
func load_game():
	var saveSpawnfinal = Global.spawnFinal
	Global.spawnFinal = false
	var file = File.new()
	if not file.file_exists("user://save.json"):
		return
	file.open("user://save.json", File.READ)
	var ruta = file.get_as_text()
	file.close()
	get_tree().change_scene(ruta)
	yield(get_tree().create_timer(0.5),"timeout")
	Global.spawnFinal = saveSpawnfinal
