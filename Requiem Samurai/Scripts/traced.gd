extends Line2D

onready var sennal = $Polygon2D			# relleno
var target								# trazado samurai
export(NodePath) var targetPath			# dirección samurai
export var trailLenght = 0				# largo trazado, n° vértices

var dibujable = true	

var point

export var Grid = 50

var figure = 0
var area = 0

var active = false

var pointR = preload("res://Escenes/Point.tscn")

func _ready():
	target = get_node(targetPath)		# carga nodo samurai, posicion
	
func _process(delta):
	global_position = Vector2(0,0)		
	global_rotation = 0
	figure = 0
	area = 0
	
	if active:
		modulate = Color(7,7,7)
	else:
		modulate = Color(3,3,3)
	
	if Input.is_action_just_pressed("vertice"):
		point = target.global_position
		point.y = point.y - 48
		
		point.x = round(point.x/Grid)*Grid
		point.y = round(point.y/Grid)*Grid
		
		var pointNew = pointR.instance()
		get_node("Node2D").add_child(pointNew)
		pointNew.position = point

		add_point(point)	# se agrega punto actual en lista ***
		
	if get_point_count() > trailLenght-1:	# largo lista > largo def
		remove_point(0)					# se borra de lista el primero
	
	if Input.is_action_just_pressed("activar"):	
		add_point(get_point_position(0))
		print("Cierre")
		# sennal.visible = true
		#modulate = Color(7,7,7)
		# sennal.set_polygon(get_points())
		dibujable = false
		
		active = true
		yield(get_tree().create_timer(0.25), "timeout")
		active = false
		
		# FIGURAS
		var nodos = get_point_count() - 1
		
		if nodos == 3:
			var n1 = get_point_position(0)
			var n2 = get_point_position(1) - n1
			var n3 = get_point_position(2) - n1
			
			n1 = Vector2(0,0)
			
			area = _triangulo(n1,n2,n3)
			figure = 1
			
			print("Triángulo, área = ", area)
		
		elif nodos == 4:
			var n1 = get_point_position(0)
			var n2 = get_point_position(1) - n1
			var n3 = get_point_position(2) - n1
			var n4 = get_point_position(3) - n1
			
			n1 = Vector2(0,0)
			
			if _rectangulo(n1,n2,n3,n4)[0]:
				area = _rectangulo(n1,n2,n3,n4)[1]
				figure = 2
				print("Rectángulo, área = ", area)
				
			elif _reloj(n1,n2,n3,n4)[0]:
				area = _reloj(n1,n2,n3,n4)[1]
				figure = 3
				print("Reloj, area = ", area)
		
		# Borrar instancias
		_delete_children($Node2D)
		clear_points()
		
		sennal.visible = false
		dibujable = true
	
	Global.figure = figure
	Global.area = area
	
	
	
	
static func _delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()




# FIGURAS 

static func _triangulo(n1,n2,n3):
	var base = abs(n1.distance_to(n2))
	var angle = n2.angle_to(n3) 
	var hip = abs(n1.distance_to(n3))
	var alt = abs(hip * sin(angle))
	
	var area = round(base*alt/2)
	
	return area
	
		
	
	

static func _rectangulo(n1,n2,n3,n4):
	var area = 0
	
	var w = false
	
	var a = abs(n1.distance_to(n2))
	var b = abs(n2.distance_to(n3))
	
	var ang1 = abs(round(rad2deg((n1-n2).angle_to(n3-n2))))
	var ang2 = abs(round(rad2deg(n2.angle_to(n4))))
	
	if ang1 == 90 and ang2 == 90:
		area = a * b
		w = true
	
	var ret = Vector2(w, area)
	
	return(ret)





static func _reloj(n1,n2,n3,n4):
	var area = 0
	
	var w = false
	
	var a = abs(n1.distance_to(n2))
	var b = abs(n2.distance_to(n3))
	var c = abs(n3.distance_to(n4))
	var d = abs(n1.distance_to(n4))

	var max1 = max(a,b)
	var max2 = max(c,d)
	
	var ang1 = abs(round(rad2deg((n1-n2).angle_to(n3-n2))))
	var ang2 = abs(round(rad2deg(n2.angle_to(n4))))
	
	if ang1 < 90 and ang2 < 90:
		area = max1 * max2 # ver como calcular el área
		w = true
	
	var ret = Vector2(w, area)
	
	return(ret)
