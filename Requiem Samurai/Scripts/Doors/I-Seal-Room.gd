extends Node2D

onready var door = $tilemaps/desbloquear
onready var door2 = $tilemaps/door/CollisionShape2D

func _ready():
	if Global.M_Earth_Sword == 1 and Global.M_Water_sword == 1:
		door.visible = false
		door2.disabled = true
