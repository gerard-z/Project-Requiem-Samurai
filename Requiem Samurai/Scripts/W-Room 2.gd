extends Node2D

onready var detArea = $Area2D

func _ready():
	detArea.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body : Node):
	if body.has_method("take_damage"):
		body.take_damage(100,self)
