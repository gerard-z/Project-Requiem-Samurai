extends Node

var figure = 0
var area = 0

var aum = 5
var attack = 1	

func _process(delta):
	area = round(area)
	if area != 0:
		print(figure, " ", area)
		if figure == 1:		#triangulo
			if attack == 0:
				attack = 1
			attack += aum
			print("attack = ", attack - 1)
