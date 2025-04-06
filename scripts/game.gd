extends Node

enum TypeTresor { BRONZE, ARGENT, OR }
enum State { MENU, STARTED, STOPPED, MAGASIN }
enum Bonus { DEPLETION, LIGHT, DECHET_DEPLETION, WEIGHT_FACTOR, SPEED, IDLE_DOWN, TRESOR_OXYGEN, DETECTION_RANGE, ALERTE, TRESOR_DETECTION }

signal depth_updated(value: float)

signal spawn_tresor(tresor: Tresor)
signal spawn_dechet(dechet: Dechet)

signal selector_is_moving(value: bool)
signal selector_moved(value: float)
signal tresor_recovered(tresor: TypeTresor)
signal tresor_thrown(tresor: TypeTresor)

signal bonus_bought(bonus: Game.Bonus, value: float, price: float)

signal enable_music()
signal disable_music()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
