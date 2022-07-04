extends Node

var figure = 0
var area = 0

var dir = 1

#enemy 01
var E1jump = 0
var FBretornable = 0
var fireball = true

var ataqpyro = 0

var gravitychange = 1

var time1 =1
var time2 =1

var time1s =1
var time2s =1

var daishi =1


var fpscount = 0

var seactivaeltrazado=false

func _process(delta): #tiempo => frames
	area = round(area)

	_gravity_time_power()
	daishi_sword()
	if area != 0:
		print(figure, " ", area)
		
		if figure == 1:		#triangulo
			if ataqpyro<0:
				ataqpyro = 3
			else:
				ataqpyro+=3
				if ataqpyro>=6:
					ataqpyro=6

			
			print("attack = ", ataqpyro)
		
		if figure ==2:
			time1s= fpscount
			daishi= -1

			
			
		if figure == 3:
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
