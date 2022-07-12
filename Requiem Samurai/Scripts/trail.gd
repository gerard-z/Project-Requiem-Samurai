extends Line2D

var point
var error = 1



func _ready():
	set_as_toplevel(true)


func _physics_process(delta):
	#if Input.is_action_just_pressed("trazo"): #la q
	#	Global.seactivaeltrazado= not Global.seactivaeltrazado
	
	#if Global.seactivaeltrazado:
	point = get_parent().global_position
	if get_point_count() > 0:
		if point.distance_to(get_point_position(get_point_count()-1)) > error:
			add_point(point)
		else:
			remove_point(0)
	else:
		add_point(point)
	#else: 
	#	clear_points()
	if points.size() > 70:
		remove_point(0)
	while points.size() > 120:
		remove_point(0)
		remove_point(0)

