extends Line2D

onready var sennal = $Polygon2D			# relleno
var target								# trazado samurai
export(NodePath) var targetPath			# dirección samurai
export var trailLenght = 0				# largo trazado, n° vértices
#var cercano								# medir dist.
var dibujable = true
var point

func _ready():
	target = get_node(targetPath)		# carga nodo samurai, posicion

func _process(delta):
	global_position = Vector2(0,0)		
	global_rotation = 0
	
	if Input.is_action_just_pressed("vertice"):
		point = target.global_position
		point.y = point.y - 48
		
		add_point(point)	# se agrega punto actual en lista ***
		
	if get_point_count() > trailLenght-1:	# largo lista > largo def
		remove_point(0)					# se borra de lista el primero
	
	#cercano = get_point_position(trailLenght-1).distance_to(get_point_position(0)) #dist entre ult y primer punto
	
	if Input.is_action_just_pressed("activar"):	
		add_point(get_point_position(0))
		print("Cierre")
		sennal.visible = true
		sennal.set_polygon(get_points())
		dibujable = false
		
		yield(get_tree().create_timer(1), "timeout")
		
		clear_points()
		sennal.visible = false
		dibujable = true
	
	#if cercano < 50 and dibujable:
	#	print("Cierre")
	#	sennal.visible = true 			# se puede dibujar polígono
	#	sennal.set_polygon(get_points())# guarda vértices de trazado
	#	dibujable = false				# se deja de dibujar, solo dibuja 1
	#	yield(get_tree().create_timer(3), "timeout")	# tiempo, espera 3 segundos para continuar
	#	sennal.visible = false
	#	dibujable = true
		
	
