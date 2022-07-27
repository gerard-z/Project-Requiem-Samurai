extends Node2D

onready var cola = $Traza

func _ready():
	Global.inFosa = true
	cola.clear_points()
