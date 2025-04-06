extends Node2D

class_name Selector

@onready var selector: Node2D = $selector

var _is_moving: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selector.position = Vector2(300, selector.position.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if _is_moving:
		var mouse_position = get_global_mouse_position() - global_position
		#var mouse_position = get_global_mouse_position() - get_parent().global_position
		if selector.position.x > 0 and selector.position.x < 600:
			selector.position = Vector2(mouse_position.x, selector.position.y)
			
		if selector.position.x >= 600:
			selector.position = Vector2(599, selector.position.y)
		if selector.position.x <= 0:
			selector.position = Vector2(1, selector.position.y)
			
		Game.selector_moved.emit(selector.position.x * 100.0 / 600.0) # emit in pourcent

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed and _is_moving:
		_is_moving = false
		Game.selector_is_moving.emit(false)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		_is_moving = true
		Game.selector_is_moving.emit(true)

func reset_value():
	selector.position = Vector2(300, selector.position.y)
