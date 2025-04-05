extends Node2D

class_name Main

const magasin_scene = preload("res://scenes/magasin.tscn")

@onready var ancre: Node2D = $ancre_parent/ancre
@onready var camera: Camera2D = $ancre_parent/camera
@onready var depth_label: Label = $CanvasLayer/HUD/depth
@onready var oxygen_label: Label = $CanvasLayer/HUD/oxygen
@onready var gold_label: Label = $CanvasLayer/HUD2/gold
@onready var cale: Cale = $CanvasLayer/cale
@onready var radar: Sprite2D = $ancre_parent/ancre/radar
@onready var transition: Sprite2D = $CanvasLayer/transition
@onready var light: PointLight2D = $ancre_parent/ancre/PointLight2D
@onready var end_label: Label = $CanvasLayer/end_label
@onready var oxygen_warning: Label = $CanvasLayer/HUD/oxygen_warning
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var bonus_label: Label = $CanvasLayer/bonus/Label
@onready var skip_shop_btn: Button = $CanvasLayer/skip_shop
@onready var entity_generation: EntityGenerator = $EntityGenerator
@onready var oxygen_completion: Sprite2D = $CanvasLayer/oxygen/completion
@onready var depth_completion: Sprite2D = $CanvasLayer/depth/completion

var _ancre_min_x: float = 50
var _ancre_max_x: float = 0

var _camera_speed: int = 100
var _camera_speed_idle: int = 10

var _transition_initial_pos: Vector2
var _ancre_initial_pos: Vector2
var _camera_initial_pos: Vector2

var _initial_light_scale: float
var _initial_light_energy: float

var _state: Game.State = Game.State.STARTED

var tresors_1_count: int = 0
var tresors_2_count: int = 0
var tresors_3_count: int = 0

var _is_moving: bool = false

var _initial_oxygen: float = 30.0
var _oxygen: float = 30.0
var _depletion_rate: float = 1

var _gold: int = 10
var _depth: float = 0

var _oxygen_needed_to_rise: float
var _initial_oxygen_completion: float
var _initial_depth_completion_y: float

var _tresors: Array[Tresor] = []

# bonus
var _depletion_bonus_rate: float = 1
var _light_rate: float = 1
var _dechet_deplete_rate: float = 1
var _weight_factor: float = 1
var _speed_rate: float = 1
var _idle_down_rate: float = 1
var _oxygen_gain_per_tresor: float = 0
var _alerte: bool = false
var _tresor_detection_range: float = 1.0
var _has_bonus_detection: bool = false

var _magasin: Magasin
var _closest_tresor: Tresor

var _selector_value: float = 50
var _montagne_1_initial_position: Vector2
var _montagne_2_initial_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_state = Game.State.MENU
	
	#VisualServer.set_default_clear_color(Color(0,0,0))
	Game.selector_moved.connect(selector_moved)
	Game.selector_is_moving.connect(selector_is_moving)
	Game.tresor_thrown.connect(tresor_thrown)
	Game.spawn_tresor.connect(spawn_tresor)
	Game.spawn_dechet.connect(spawn_dechet)
	Game.bonus_bought.connect(bonus_bought)
	
	_transition_initial_pos = transition.position
	_ancre_initial_pos = ancre.position
	_camera_initial_pos = camera.position
	_initial_oxygen_completion = oxygen_completion.scale.x
	_initial_depth_completion_y = depth_completion.position.y
	
	_montagne_1_initial_position = $ancre_parent/camera/montagne_1.position
	_montagne_2_initial_position = $ancre_parent/camera/montagne_2.position
	
	update_bonus_label()
	
	light.texture_scale = 4
	light.energy = 2
	
	_initial_light_scale = light.texture_scale
	_initial_light_energy = light.energy
	
	_ancre_max_x = get_viewport_rect().size.x - 50
	#start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _state == Game.State.STARTED:
		if _is_moving:
			camera.position.y += delta * _camera_speed * _speed_rate
			ancre.position.y += delta * _camera_speed * _speed_rate
			_depth += delta * _camera_speed * _speed_rate
		else:
			camera.position.y += delta * _camera_speed_idle * _speed_rate * _idle_down_rate
			ancre.position.y += delta * _camera_speed_idle * _speed_rate * _idle_down_rate
			_depth += delta * _camera_speed_idle * _speed_rate * _idle_down_rate
		
		if ancre.position.y < 500 and light.energy > 0.75:
			light.energy *= 0.998
		elif light.energy < 1.05 and light.texture_scale > 0.75:
			light.texture_scale *= 0.998
		
		if _is_moving:
			_depletion_rate = 1
		else:
			_depletion_rate = 0.5
			
		_oxygen -= _depletion_rate * 0.01 * cale.get_weigt_depletion_factor() * _depletion_bonus_rate * _weight_factor
		_oxygen_needed_to_rise = 15 * cale.get_weigt_depletion_factor()
		oxygen_completion.scale.x = _oxygen * _initial_oxygen_completion / 100
		depth_completion.position.y += _depth / 10000
		
		Game.depth_updated.emit(ancre.position.y)
		
		update_labels()
		
		if _oxygen < 0:
			stop_game(true)
		
		var lower_distance = -1
		var closest = null
		for tresor in _tresors:
			if !is_instance_valid(tresor): 
				continue
				
			if tresor.global_position.y < ancre.global_position.y and (tresor.global_position - ancre.global_position).length() > 400:
				tresor.queue_free()
				continue
				
			var distance = abs((tresor.global_position - ancre.global_position).length())
			if lower_distance == -1 or distance < lower_distance:
				lower_distance = distance
				closest = tresor
				
		_closest_tresor = closest
		
		if _has_bonus_detection and _closest_tresor != null and (_closest_tresor.global_position - ancre.global_position).length() < 200 * _tresor_detection_range:
			radar.visible = true
			#$Line2D.points = [_closest_tresor.global_position, ancre.global_position]
			var angle = rad_to_deg((_closest_tresor.global_position - ancre.global_position).angle()) + 45 + 45
			move_radar(angle)
		else:
			radar.visible = false
			
	handle_paralax()
			
func update_labels():
	depth_label.text = str(ancre.position.y)
	oxygen_label.text = str(_oxygen)
	gold_label.text = str(_gold)
	$CanvasLayer/depth/completion/Label4.text = str(_depth as int)
	
	oxygen_warning.visible = false
	if _alerte:
		if _oxygen < _oxygen_needed_to_rise:
			oxygen_label.modulate = Color.RED
			oxygen_warning.visible = true
		elif _oxygen < _oxygen_needed_to_rise * 1.10:
			oxygen_label.modulate = Color.ORANGE
			oxygen_warning.visible = true
		elif _oxygen < _oxygen_needed_to_rise * 2:
			oxygen_label.modulate = Color.YELLOW

func selector_moved(value: float):
	#ancre.position = Vector2(((_ancre_max_x - _ancre_min_x) * value / 100) + 50, ancre.position.y)
	var new_x = ((_ancre_max_x - _ancre_min_x) * value / 100) + 50
	ancre.position = ancre.position.lerp(Vector2(new_x, ancre.position.y), 0.1)
	_selector_value = value
	print(str(value))

func selector_is_moving(value: bool):
	if _state == Game.State.MENU:
		_state = Game.State.STARTED
		$CanvasLayer/tuto.visible = false
	_is_moving = value

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("tresor"):
		var tresor = area.get_parent().get_parent() as Tresor
		print("un trésor ! " + str(tresor.type))
		
		if tresor.type == Game.TypeTresor.BRONZE:
			tresors_1_count += 1
		elif tresor.type == Game.TypeTresor.ARGENT:
			tresors_2_count += 1
		elif tresor.type == Game.TypeTresor.OR:
			tresors_3_count += 1
		
		Game.tresor_recovered.emit(tresor.type)
		
		_oxygen += _oxygen_gain_per_tresor
		
		tresor.queue_free()
		_tresors.erase(tresor)
	elif area.is_in_group("dechet"):
		var dechet = area.get_parent().get_parent() as Dechet
		print("un déchet ! " + str(dechet.size))
		
		_oxygen -= dechet.size * 10 * _dechet_deplete_rate
		
		dechet.queue_free()

func tresor_thrown(tresor: Game.TypeTresor):
	if tresor == Game.TypeTresor.BRONZE:
		tresors_1_count -= 1
	elif tresor == Game.TypeTresor.ARGENT:
		tresors_2_count -= 1
	elif tresor == Game.TypeTresor.OR:
		tresors_3_count -= 1


func start_game():
	for t in _tresors:
		_tresors.erase(t)
		if is_instance_valid(t):
			t.queue_free()
	
	transition.position = _transition_initial_pos
	_oxygen = _initial_oxygen
	cale.reset()
	tresors_1_count = 0
	tresors_2_count = 0
	tresors_3_count = 0
	
	_depth = 0
	
	light.texture_scale = _initial_light_scale
	light.energy = _initial_light_energy
	
	ancre.position = _ancre_initial_pos
	camera.position = _camera_initial_pos
	
	oxygen_completion.scale.x = _initial_oxygen_completion
	depth_completion.position.y = _initial_depth_completion_y 
	
	radar.visible = false
	cale.visible = true
	entity_generation.start_generation()
	
	update_labels()
	
	_state = Game.State.STARTED

func stop_game(defeat: bool):
	_state = Game.State.STOPPED
	var message = ""
	cale.visible = false
	
	var bonus: float = 0
	if defeat:
		bonus = (tresors_1_count * 0.66) + (tresors_2_count * 0.5) + (tresors_3_count * 0.25)
		print("you lose your submarine, you manage to retrieve somehow pieces of your treasures +" + str(bonus))
		message = "You lose your submarine at a depth of " + str(_depth as int) + "\nYou manage somehow to retrieve pieces of your treasures +" + str(bonus) + "G"
	else:
		bonus = tresors_1_count + tresors_2_count + tresors_3_count
		print("your submarine rises to the surface, you sold all your treasures +" + str(bonus))
		
		var lose_percent = 0
		var bonus_lose_factor = 0
		if _oxygen < _oxygen_needed_to_rise:
			bonus_lose_factor = _oxygen / _oxygen_needed_to_rise
			lose_percent = 1.0 - bonus_lose_factor
			bonus *= bonus_lose_factor
			
		message = "You have gone to a depth of " + str(_depth) + " meters. \nYour submarine rises to the surface\n"
		if lose_percent > 0:
			message += "You hadn't enough oxygen to rise, you lose " + str((lose_percent * 100) as int) + "% of your treasures\n"
		
		message += "You sold all your treasures +" + str(bonus as int) + "G"

	_gold += bonus as int
	
	entity_generation.stop_generation()
	
	_selector_value = 50
	handle_paralax()
	
	var tween_transition = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween_transition.tween_property(transition, "position", Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2), 0.5)
	tween_transition.tween_callback(show_end_menu.bind(message))

func show_end_menu(message: String):
	end_label.visible = true
	end_label.text = message
	update_labels()
	
	var magasin_scn = magasin_scene.instantiate()
	var magasin = magasin_scn as Magasin
	magasin._init_scene(_gold)
	magasin.main = self
	canvas_layer.add_child(magasin)
	magasin.position = Vector2(get_viewport_rect().size.x / 2, (get_viewport_rect().size.y / 2) + 125)
	_magasin = magasin
	
	skip_shop_btn.visible = true

func _on_remonter_pressed() -> void:
	stop_game(false)

func spawn_tresor(tresor: Tresor):
	add_child(tresor)
	var x = (randf() * get_viewport_rect().size.x * 0.8) + (get_viewport_rect().size.x * 0.1)
	var y = camera.position.y + (get_viewport_rect().size.y * 0.75) #+ (randf() * get_viewport_rect().size.y * 0.33)
	tresor.position = Vector2(x, y)
	print("new spawn tresor")
	
	_tresors.push_back(tresor)
	
func spawn_dechet(dechet: Dechet):
	add_child(dechet)

func bonus_bought(bonus: Game.Bonus, value: float, price: float):
	match bonus:
		Game.Bonus.DEPLETION:
			_depletion_bonus_rate *= 1 - value #ligne 66
		Game.Bonus.DECHET_DEPLETION:
			_dechet_deplete_rate *= 1 - value #ligne 103
		Game.Bonus.WEIGHT_FACTOR:
			_weight_factor *= 1 - value #ligne 66
		Game.Bonus.SPEED:
			_speed_rate *= 1 + value #ligne 55 56 58 59
		Game.Bonus.IDLE_DOWN:
			_idle_down_rate *= 1 - value #ligne 58 59
		Game.Bonus.TRESOR_OXYGEN:
			_oxygen_gain_per_tresor += value #ligne 98
		Game.Bonus.DETECTION_RANGE: # à faire
			_tresor_detection_range *= 1 + value
		Game.Bonus.LIGHT: # à faire
			_light_rate *= 1 + value
		Game.Bonus.ALERTE:
			_alerte = true
		Game.Bonus.TRESOR_DETECTION:
			_has_bonus_detection = true
	
	_gold -= price
	
	update_labels()
	update_bonus_label()
	
	restart_game()
			
func has_bonus_alert():
	return _alerte
	
func has_bonus_detection():
	return _has_bonus_detection

func update_bonus_label():
	bonus_label.text = "DEPLETION : " + str(_depletion_bonus_rate) + "\n"
	bonus_label.text += "DECHET_DEPLETION : " + str(_dechet_deplete_rate) + "\n"
	bonus_label.text += "WEIGHT_FACTOR : " + str(_weight_factor) + "\n"
	bonus_label.text += "SPEED : " + str(_speed_rate) + "\n"
	bonus_label.text += "IDLE_DOWN : " + str(_idle_down_rate) + "\n"
	bonus_label.text += "TRESOR_OXYGEN : " + str(_oxygen_gain_per_tresor) + "\n"
	bonus_label.text += "ALERTE : " + str(_alerte) + "\n"
	bonus_label.text += "DETECTION_RANGE : " + str(_tresor_detection_range) + "\n"
	bonus_label.text += "LIGHT : " + str(_light_rate)

func _on_skip_shop_pressed() -> void:
	restart_game()

func restart_game():
	skip_shop_btn.visible = false
	_magasin.queue_free()
	end_label.visible = false
	
	light.texture_scale = _initial_light_scale
	light.energy = _initial_light_energy

	ancre.position = _ancre_initial_pos
	camera.position = _camera_initial_pos
	oxygen_completion.scale.x = _oxygen * _initial_oxygen_completion / 100
	
	var tween_transition = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween_transition.tween_property(transition, "position", Vector2(get_viewport_rect().size.x / 2 * 3.5, get_viewport_rect().size.y / 2), 0.5)
	tween_transition.tween_callback(restart_transition_ended)

func restart_transition_ended():
	_state = Game.State.MENU
	$CanvasLayer/tuto.visible = true

func move_radar(angle: float):
	var real_angle = angle + 225
	radar.rotation_degrees = lerpf(radar.rotation_degrees, real_angle, 0.1)

func handle_paralax():
	if _selector_value < 5 or _selector_value > 95: return
	
	var montagne_1 = $ancre_parent/camera/montagne_1
	var montagne_2 = $ancre_parent/camera/montagne_2
	
	var middle = (get_viewport_rect().size.x / 2)
	montagne_1.position = montagne_1.position.lerp(Vector2(_montagne_1_initial_position.x + _selector_value * 0.5, montagne_1.position.y), 0.1)
	montagne_2.position = montagne_2.position.lerp(Vector2(_montagne_2_initial_position.x - _selector_value * 0.5, montagne_2.position.y), 0.1)
