extends Node

var figure = 0
var area = 0


var ataqpyro = 0

var gravitychange = 1

var time1 =1
var time2 =1

var time1s =1
var time2s =1

var daishi =1
var daishifix =1

func _process(delta): #tiempo => frames
	area = round(area)

	_gravity_time_power()
	daishi_sword()
	if area != 0:
		print(figure, " ", area)
		
		if figure == 1:		#triangulo
			ataqpyro = 5
			
			print("attack = ", ataqpyro)
		
		if figure ==2:
			time1s= OS.get_unix_time()
			daishi= -1
			daishifix = 0
			
			
		if figure == 3:
			time1= OS.get_unix_time()
			gravitychange=-1

func _gravity_time_power():
	time2 = OS.get_unix_time()
	var time_elapsed = time2 - time1
	
	if time_elapsed >= 3:
		gravitychange=1


var contador = 0
func _physics_process(delta):
	contador+=1


func daishi_sword():
	time2s = OS.get_unix_time()
	var time_elapseds = time2s - time1s
	
	if time_elapseds >= 3:
		daishi=1
