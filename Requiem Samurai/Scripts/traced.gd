extends Line2D

onready var sennal = $Polygon2D			# relleno
var target								# trazado samurai
export(NodePath) var targetPath			# dirección samurai
export var trailLenght = 0				# largo trazado, n° vértices
var dibujable = true	

var point

export var Grid = 50

var pointR = preload("res://Escenes/Point.tscn")

func _ready():
	target = get_node(targetPath)		# carga nodo samurai, posicion
	
func _process(delta):
	global_position = Vector2(0,0)		
	global_rotation = 0
	
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
		sennal.visible = true
		sennal.set_polygon(get_points())
		dibujable = false
		
		yield(get_tree().create_timer(0.5), "timeout")
		
		_delete_children($Node2D)
#		playback.travel("None")
		clear_points()
		sennal.visible = false
		dibujable = true
	
static func _delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
