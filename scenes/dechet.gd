extends Node2D

class_name Dechet

@export var size: float = 1


func _ready() -> void:
	scale = Vector2(size, size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init_scene(new_size: float, text: Texture2D, rot: float):
	size = new_size
	rotation_degrees = rot
	$Sprite2D.texture = text
