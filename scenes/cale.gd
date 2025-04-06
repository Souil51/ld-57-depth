extends Node2D

class_name Cale

@onready var label_tresors_1: Label = $tresors_1/Label
@onready var label_tresors_2: Label = $tresors_2/Label
@onready var label_tresors_3: Label = $tresors_3/Label
@onready var label_weigt_factor: Label = $weigt_factor

var tresors_1_count: int = 0
var tresors_2_count: int = 0
var tresors_3_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.tresor_recovered.connect(tresor_recovered)
	
	label_tresors_1.text = "x0"
	label_tresors_2.text = "x0"
	label_tresors_3.text = "x0"

func _process(delta: float) -> void:
	pass

func tresor_recovered(typeTresor: Game.TypeTresor):
	
	if typeTresor == Game.TypeTresor.BRONZE:
		tresors_1_count += 1
	elif typeTresor == Game.TypeTresor.ARGENT:
		tresors_2_count += 1
	elif typeTresor == Game.TypeTresor.OR:
		tresors_3_count += 1
		
	update_labels()

func get_weigt_depletion_factor() -> float:
	var factor: float = 1.0
	
	factor += tresors_1_count * 0.01
	factor += tresors_2_count * 0.02
	factor += tresors_3_count * 0.05
	
	return factor

func _on_tresors_1_pressed() -> void:
	if tresors_1_count == 0:
		return
		
	tresors_1_count -= 1
	Game.tresor_thrown.emit(Game.TypeTresor.BRONZE)
	update_labels()

func _on_tresors_2_pressed() -> void:
	if tresors_2_count == 0:
		return
		
	tresors_2_count -= 1
	Game.tresor_thrown.emit(Game.TypeTresor.ARGENT)
	update_labels()

func _on_tresors_3_pressed() -> void:
	if tresors_3_count == 0:
		return
		
	tresors_3_count -= 1
	Game.tresor_thrown.emit(Game.TypeTresor.OR)
	update_labels()

func update_labels():
	label_tresors_1.text = "x" + str(tresors_1_count)
	label_tresors_2.text = "x" + str(tresors_2_count)
	label_tresors_3.text = "x" + str(tresors_3_count)
	label_weigt_factor.text = "The weigt make your oxygen depletes " + str(get_weigt_depletion_factor()) + " times faster"

func reset():
	tresors_1_count = 0
	tresors_2_count = 0
	tresors_3_count = 0
	update_labels()
