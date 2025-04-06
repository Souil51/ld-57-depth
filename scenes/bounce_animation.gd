extends Node2D

@export var max: float = 1.1
@export var min: float = 0.9
@export var duration: float = 2
@export var horizontal: bool = true
@export var vertical: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().scale = Vector2(min, min)
	
	var max_x = 1
	if horizontal: max_x = max
	var min_x = 1
	if horizontal: min_x = min
	
	var max_y = 1
	if vertical: max_y = max
	var min_y = 1
	if vertical: min_y = min
	
	var tween_transition = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_loops()
	tween_transition.tween_property(get_parent(), "scale", Vector2(max_x, max_y), duration / 2)
	tween_transition.tween_property(get_parent(), "scale", Vector2(min_x, min_y), duration / 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
