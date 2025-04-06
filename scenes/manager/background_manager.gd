extends Node2D

class_name BackgroundManager

const entity_scene = preload("res://scenes/background_entity.tscn")

@export var textures: Array[Texture2D] = []
@export var speed: float = 25

var _sprites: Array[BackgroundEntity] = []

var time_passed = 0
var _time_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta * _time_speed
	
	for s in _sprites:
		if !is_instance_valid(s): continue
		if (s.scale.x > 0 and s.position.x > get_viewport_rect().size.x + 50) or (s.scale.x <= 0 and s.position.x < -50):
			_sprites.erase(s)
			s.queue_free()

func instantiate_sprite():
	var direction = randi_range(0, 1)
	if direction == 0: direction = -1
	
	var new_entity = entity_scene.instantiate()
	var index = randi_range(0, textures.size() - 1)
	
	var base_scale = 0.25
	if index == 0:
		base_scale = 0.1
		
	var name = "background" + str(get_child_count())
	
	var pos_x = 0
	if direction == 1:
		pos_x = -50
	else:
		pos_x = get_viewport_rect().size.x + 50
		
	var screen_height = get_viewport_rect().size.x
	var pos_y = randi_range(screen_height * 0.1, screen_height * 0.9)
	
	var new_scale = Vector2(0.25 * direction, 0.25)
	if index == 0:
		new_scale = Vector2(0.1 * direction, 0.1)
	
	new_entity._init_scene(textures[index], base_scale, name, Vector2(pos_x, pos_y), new_scale)

	add_child(new_entity)
	
	_sprites.push_back(new_entity as BackgroundEntity)

func _on_timer_timeout() -> void:
	instantiate_sprite()
