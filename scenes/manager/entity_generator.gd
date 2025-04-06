extends Node2D

class_name EntityGenerator

const tresor_scene = preload("res://scenes/tresor.tscn")
const dechet_scene = preload("res://scenes/dechet.tscn")

@export var textures: Array[Texture2D] = []
@export var dechetTextures: Array[Texture2D] = []

var _depth: float = 0

var _is_moving: bool = false

var _steps_tresors_1: Array = [ 0, 1500, 3000, 6000 ]
var _steps_tresors_1_factors: Array = [ 0.35, 0.15, 0.1, 0.03 ]

var _steps_tresors_2: Array = [ 1250, 1500, 3000, 5000 ]
var _steps_tresors_2_factors: Array = [ 0.10, 0.35, 0.15, 0.05 ]

var _steps_tresors_3: Array = [ 2500, 4000, 6000, 8000 ]
var _steps_tresors_3_factors: Array = [ 0.03, 0.1, 0.2, 0.15 ]

var _steps_dechet: Array = [ 0, 2003, 4000, 6000, 10000 ]
var _steps_dechet_factors: Array = [ 0.3, 0.4, 0.5, 0.7, 0.8 ]

func _ready() -> void:
	Game.depth_updated.connect(depth_updated)
	Game.selector_is_moving.connect(selector_is_moving)

func _process(delta: float) -> void:
	pass

func depth_updated(value: float):
	_depth = value

func selector_is_moving(value: bool):
	_is_moving = value
	
	if _is_moving:
		$Timer.wait_time = 1.0
	else:
		$Timer.wait_time = 10.0

func _on_timer_timeout() -> void:
	var t1_next_steps = _steps_tresors_1.filter(func(x): return x > _depth)
	var t1_factor = 0
	if t1_next_steps.size() > 0:
		var t1_depth = t1_next_steps[0]
		var index_t1 = _steps_tresors_1.find(t1_depth)
		t1_factor = _steps_tresors_1_factors[index_t1 - 1]
		
	
	var t2_next_steps = _steps_tresors_2.filter(func(x): return x > _depth)
	var t2_factor = 0
	if t2_next_steps.size() > 0:
		var t2_depth = t2_next_steps[0]
		var index_t2 = _steps_tresors_2.find(t2_depth)
		t2_factor = _steps_tresors_2_factors[index_t2]
	
	var t3_next_steps = _steps_tresors_3.filter(func(x): return x > _depth)
	var t3_factor = 0
	if t3_next_steps.size() > 0:
		var t3_depth = t3_next_steps[0]
		var index_t3 = _steps_tresors_3.find(t3_depth)
		t3_factor = _steps_tresors_3_factors[index_t3]
	
	var dechet_next_steps = _steps_dechet.filter(func(x): return x < _depth)
	var dechet_factor = 0
	if dechet_next_steps.size() > 0:
		var dechet_depth = dechet_next_steps[0]
		var index_dechet = _steps_dechet.find(dechet_depth)
		dechet_factor = _steps_dechet_factors[index_dechet]
	
	var is_t1_spawn = randf() <= t1_factor
	var is_t2_spawn = randf() <= t2_factor
	var is_t3_spawn = randf() <= t3_factor
	var is_dechet_spawn = randf() <= dechet_factor
	
	var already_spawned = false
	if is_t1_spawn:
		spawn_tresor(Game.TypeTresor.BRONZE)
		already_spawned = true
		
	if is_t2_spawn and !already_spawned:
		spawn_tresor(Game.TypeTresor.ARGENT)
		already_spawned = true
		
	if is_t3_spawn and !already_spawned:
		spawn_tresor(Game.TypeTresor.OR)
	
	if is_dechet_spawn:
		spawn_dechet(1.0 + (randf() * 0.5))
	

func spawn_tresor(type: Game.TypeTresor):
	var new_tresor_scene = tresor_scene.instantiate()
	var tresor = new_tresor_scene as Tresor
	tresor.name = "tresor" + str(randi_range(0, 99999))
	tresor.init_scene(type, textures[type])
	Game.spawn_tresor.emit(tresor)
	
func spawn_dechet(size: float):
	var textureIndex = randi_range(0, dechetTextures.size() - 1)
	var new_dechet_scene = dechet_scene.instantiate()
	var dechet = new_dechet_scene as Dechet
	dechet.name = "dechet" + str(randi_range(0, 99999))
	var rot = randi_range(-15, 15)
	dechet.init_scene(size, dechetTextures[textureIndex], rot)
	Game.spawn_dechet.emit(dechet)

func start_generation():
	$Timer.start()
	
func stop_generation():
	$Timer.stop()
