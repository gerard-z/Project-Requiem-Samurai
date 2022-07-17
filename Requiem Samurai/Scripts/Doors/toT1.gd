extends Node2D
onready var A = $Area2D

func _ready():
	A.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node):
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://Escenes/MainMenu.tscn") #POR AHORA
