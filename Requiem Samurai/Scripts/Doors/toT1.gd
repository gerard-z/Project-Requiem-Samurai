extends Node2D
onready var A = $Area2D

export var escena_objetivo : String = "null"
export var toEnd = false
func _ready():
	A.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node):
	get_tree().change_scene(escena_objetivo)
	if toEnd:
		Global.spawnFinal = true
	else:
		Global.spawnFinal = false
