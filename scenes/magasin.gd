extends Node2D

class_name Magasin

@onready var label_0: Label = $item_1/Label
@onready var label_1: Label = $item_2/Label
@onready var label_2: Label = $item_3/Label

@onready var label_titre_0: Label = $item_1/Label_Titre
@onready var label_titre_1: Label = $item_2/Label_Titre
@onready var label_titre_2: Label = $item_3/Label_Titre

@onready var label_value_0: Label = $item_1/Label_Value
@onready var label_value_1: Label = $item_2/Label_Value
@onready var label_value_2: Label = $item_3/Label_Value

@onready var label_price_0: Label = $item_1/Label_Price
@onready var label_price_1: Label = $item_2/Label_Price
@onready var label_price_2: Label = $item_3/Label_Price

@onready var message_label: Label = $Message

@export var main: Main

var _gold: float = 0

var _bonus_0: Game.Bonus
var _bonus_0_value: int
var _bonus_0_price: float

var _bonus_1: Game.Bonus
var _bonus_1_value: int
var _bonus_1_price: float

var _bonus_2: Game.Bonus
var _bonus_2_value: int
var _bonus_2_price: float

func _ready() -> void:
	generate_magasin()

func _process(delta: float) -> void:
	pass

func _init_scene(gold: float):
	_gold = gold

func generate_magasin():
	for i in range(0, 3):
		var bonus = 0
		var price = 3
		
		if i == 1 and !main.has_bonus_alert():
			bonus = Game.Bonus.ALERTE
		elif i == 1 and !main.has_bonus_detection():
			bonus = Game.Bonus.TRESOR_DETECTION
		elif main.has_bonus_alert():
			bonus = randi_range(0, 7)
		
		var value = randi_range(3, 8)
		
		if bonus == 8 or bonus == 9:
			price = 15
		else:
			price += value
		
		show_bonus(i, bonus, value, price)

func show_bonus(index: int, bonus: Game.Bonus, value: int, price: float):
	var label
	if index == 0:
		_bonus_0 = bonus
		_bonus_0_value = value
		_bonus_0_price = price
		label_0.text = get_description_bonus(bonus)
		label_titre_0.text = get_string_bonus(bonus)
		label_value_0.text = "+" + str(value) + "%"
		label_price_0.text = str(price) + "G"
	elif index == 1:
		_bonus_1 = bonus
		_bonus_1_value = value
		_bonus_1_price = price
		label_1.text = get_description_bonus(bonus)
		label_titre_1.text = get_string_bonus(bonus)
		label_value_1.text =  "+" + str(value) + "%"
		label_price_1.text = str(price) + "G"
	elif index == 2:
		_bonus_2 = bonus
		_bonus_2_value = value
		_bonus_2_price = price
		label_2.text = get_description_bonus(bonus)
		label_titre_2.text = get_string_bonus(bonus)
		label_value_2.text =  "+" + str(value) + "%"
		label_price_2.text = str(price) + "G"

func get_string_bonus(bonus: Game.Bonus):
	match bonus:
		Game.Bonus.DEPLETION:
			return "Depletion"
		Game.Bonus.DECHET_DEPLETION:
			return "Scraps"
		Game.Bonus.WEIGHT_FACTOR:
			return "Weight"
		Game.Bonus.SPEED:
			return "Speed"
		Game.Bonus.IDLE_DOWN:
			return "Idle descent"
		Game.Bonus.TRESOR_OXYGEN:
			return "Oxygen"
		Game.Bonus.DETECTION_RANGE: # à faire
			return "Tresor detection"
		Game.Bonus.LIGHT: # à faire
			return "Light"
		Game.Bonus.ALERTE:
			return "Oxygen alert"
		Game.Bonus.TRESOR_DETECTION:
			return "Tresor detection"
			
func get_description_bonus(bonus: Game.Bonus):
	match bonus:
		Game.Bonus.DEPLETION:
			return "Reduce oxygen depletion rate"
		Game.Bonus.DECHET_DEPLETION:
			return "Reduce oxygen lost on scraps hit"
		Game.Bonus.WEIGHT_FACTOR:
			return "Reduce the weight of treasures"
		Game.Bonus.SPEED:
			return "Increase the descent speed"
		Game.Bonus.IDLE_DOWN:
			return "Reduce the idle descent speed"
		Game.Bonus.TRESOR_OXYGEN:
			return "Gain oxygen when collection treasure"
		Game.Bonus.DETECTION_RANGE: # à faire
			return "Increase treasure detection rate"
		Game.Bonus.LIGHT: # à faire
			return "Increase the light in depth"
		Game.Bonus.ALERTE:
			return "Display an alert to know when rise to the surface"
		Game.Bonus.TRESOR_DETECTION:
			return "Display a light clue to know where are treasures"

func _on_bonus_0_pressed() -> void:
	if _gold >= _bonus_0_price:
		Game.bonus_bought.emit(_bonus_0, _bonus_0_value / 100.0, _bonus_0_price)
	else:
		message_label.text = "Not enough money"
		message_label.visible = true

func _on_bonus_1_pressed() -> void:
	if _gold >= _bonus_1_price:
		Game.bonus_bought.emit(_bonus_1, _bonus_1_value / 100.0, _bonus_1_price)
	else:
		message_label.text = "Not enough money"
		message_label.visible = true

func _on_bonus_2_pressed() -> void:
	if _gold >= _bonus_2_price:
		Game.bonus_bought.emit(_bonus_2, _bonus_2_value / 100.0, _bonus_2_price)
	else:
		message_label.text = "Not enough money"
		message_label.visible = true
