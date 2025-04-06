extends Node2D

class_name BackgroundEntity

@onready var _sprite: Sprite2D = $Sprite2D

var _speed: float = 25
var _time_speed = 1
var _time_passed = 0
var _y_amplitude: float = 1

var _texture: Texture2D
var _pos: Vector2
var _name: String
var _scale: Vector2
var _modulate: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_sprite.texture = _texture
	position = _pos
	name = _name
	scale = _scale
	_sprite.modulate = _modulate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_time_passed += delta * _time_speed
	
	if scale.x > 0:
		position.x += delta * _speed
	else:
		position.x -= delta * _speed
	
	position.y = position.y + (0.2 * sin(_time_passed * _y_amplitude))
	
func _init_scene(text: Texture2D, scale_base: float, name: String, start_pos: Vector2, start_scale: Vector2):
	var direction = randi_range(0, 1)
	if direction == 0: direction = -1
	
	_texture = text
	_speed = randf_range(10, 50)
	_y_amplitude = randf_range(0.5, 1.5)
	
	_pos = start_pos
	_name = name
	_scale = start_scale
	
	var gray = randf_range(0.05, 0.10)
	_modulate = Color(gray, gray, gray, 1)
