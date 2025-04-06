extends Node2D

class_name Tresor

@export var type: Game.TypeTresor = Game.TypeTresor.BRONZE
@onready var sprite: Sprite2D = $sprite

@export var _texture: Texture2D

#var _texture: Texture

func _ready() -> void:
	sprite.texture = _texture

func _process(delta: float) -> void:
	pass
	
func init_scene(new_type : Game.TypeTresor, texture: Texture):
	type = new_type
	if type > 2:
		type = 2
	elif type < 0:
		type = 0
	
	_texture = texture
