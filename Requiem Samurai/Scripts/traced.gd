extends Line2D

onready var sennal = $Polygon2D
var target
export(NodePath) var targetPath
export var trailLenght = 0
var cercano
var dibujable = true
var ultimo

func _ready():
	target = get_node(targetPath)

func _process(delta):
	global_position = Vector2(0,0)
	global_rotation = 0
	add_point(target.global_position)
	ultimo = get_point_count()
	if ultimo > trailLenght:
		remove_point(0)
	cercano = get_point_position(ultimo-2).distance_to(get_point_position(0))
	if cercano < 50 and dibujable:
		print("Cierre")
		sennal.visible = true
		sennal.set_polygon(get_points())
		dibujable = false
		yield(get_tree().create_timer(3), "timeout")
		sennal.visible = false
		dibujable = true
		
	
