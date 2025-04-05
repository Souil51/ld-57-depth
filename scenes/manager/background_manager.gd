extends Node2D

class_name BackgroundManager

@export var textures: Array[Texture2D] = []
@export var speed: float = 100

var _sprites: Array[Sprite2D] = []

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
		
		if s.scale.x > 0:
			s.position.x += delta * speed
		else:
			s.position.x -= delta * speed
		
		s.position.y = s.position.y + (0.5 * sin(time_passed * 2))
	
	#print(str(sin(Time.get_ticks_usec() / 1000000)))
	#print(str(Time.get_ticks_usec() / 100000))

func instantiate_sprite():
	var direction = randi_range(0, 1)
	if direction == 0: direction = -1
	
	var sprite = Sprite2D.new()
	var index = randi_range(0, textures.size() - 1)
	sprite.texture = textures[index]
	
	var pos_x = 0
	if direction == 1:
		pos_x = -50
	else:
		pos_x = get_viewport_rect().size.x + 50
		
	var screen_height = get_viewport_rect().size.x
	var pos_y = randi_range(screen_height * 0.1, screen_height * 0.9)
	sprite.position = Vector2(pos_x, pos_y)
	sprite.name = "background" + str(get_child_count())
	sprite.scale = Vector2(0.25 * direction, 0.25)
	
	var gray = randf_range(0.05, 0.15)
	sprite.modulate = Color(gray, gray, gray, 1)
	add_child(sprite)
	
	_sprites.push_back(sprite)

func _on_timer_timeout() -> void:
	instantiate_sprite()
