extends Line2D

var point
var error = 1

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	point = get_parent().global_position
	if get_point_count() > 0:
		if point.distance_to(get_point_position(get_point_count()-1)) > error:
			add_point(point)
		else:
			remove_point(0)
	else:
		add_point(point)
	if points.size() > 50:
		remove_point(0)
	
