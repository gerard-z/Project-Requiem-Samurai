extends Node

var figure = 0
var area = 0


var ataqpyro = 0

func _process(delta):
	area = round(area)
	if area != 0:
		print(figure, " ", area)
		
		if figure == 1:		#triangulo
			ataqpyro = 5
			print("attack = ", ataqpyro)
