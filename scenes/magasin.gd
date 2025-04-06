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

@onready var icon_0: Sprite2D = $item_1/Sprite2D
@onready var icon_1: Sprite2D = $item_2/Sprite2D
@onready var icon_2: Sprite2D = $item_3/Sprite2D

@onready var label_gold: Label = $Label_Gold

@onready var message_label: Label = $Message

@export var main: Main

@export var _texture_oxygen: Texture2D
@export var _texture_light: Texture2D
@export var _texture_tresor: Texture2D
@export var _texture_acceleration: Texture2D

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
	label_gold.text = "You have " + str(_gold)
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
		else:
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
		icon_0.texture = get_icon_bonus(bonus)
		icon_0.scale = Vector2.ONE * get_icon_scale_bonus(bonus)
		label_0.text = get_description_bonus(bonus)
		label_titre_0.text = get_string_bonus(bonus)
		if bonus != Game.Bonus.ALERTE and bonus != Game.Bonus.TRESOR_DETECTION:
			label_value_0.text =  "+" + str(value) + "%"
		else:
			label_value_0.text = ""
		label_price_0.text = str(price)
	elif index == 1:
		_bonus_1 = bonus
		_bonus_1_value = value
		_bonus_1_price = price
		icon_1.texture = get_icon_bonus(bonus)
		icon_1.scale = Vector2.ONE * get_icon_scale_bonus(bonus)
		label_1.text = get_description_bonus(bonus)
		label_titre_1.text = get_string_bonus(bonus)
		if bonus != Game.Bonus.ALERTE and bonus != Game.Bonus.TRESOR_DETECTION:
			label_value_1.text =  "+" + str(value) + "%"
		else:
			label_value_1.text = ""
		label_price_1.text = str(price)
	elif index == 2:
		_bonus_2 = bonus
		_bonus_2_value = value
		_bonus_2_price = price
		icon_2.texture = get_icon_bonus(bonus)
		icon_2.scale = Vector2.ONE * get_icon_scale_bonus(bonus)
		label_2.text = get_description_bonus(bonus)
		label_titre_2.text = get_string_bonus(bonus)
		if bonus != Game.Bonus.ALERTE and bonus != Game.Bonus.TRESOR_DETECTION:
			label_value_2.text =  "+" + str(value) + "%"
		else:
			label_value_2.text = ""
		label_price_2.text = str(price)

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

func get_icon_bonus(bonus: Game.Bonus):
	match bonus:
		Game.Bonus.DEPLETION:
			return _texture_oxygen
		Game.Bonus.DECHET_DEPLETION:
			return _texture_oxygen
		Game.Bonus.WEIGHT_FACTOR:
			return _texture_oxygen
		Game.Bonus.SPEED:
			return _texture_acceleration
		Game.Bonus.IDLE_DOWN:
			return _texture_acceleration
		Game.Bonus.TRESOR_OXYGEN:
			return _texture_oxygen
		Game.Bonus.DETECTION_RANGE: # à faire
			return _texture_tresor
		Game.Bonus.LIGHT: # à faire
			return _texture_light
		Game.Bonus.ALERTE:
			return _texture_oxygen
		Game.Bonus.TRESOR_DETECTION:
			return _texture_tresor
			
func get_icon_scale_bonus(bonus: Game.Bonus):
	match bonus:
		Game.Bonus.DEPLETION:
			return 0.45
		Game.Bonus.DECHET_DEPLETION:
			return 0.45
		Game.Bonus.WEIGHT_FACTOR:
			return 0.45
		Game.Bonus.SPEED:
			return 0.3
		Game.Bonus.IDLE_DOWN:
			return 0.3
		Game.Bonus.TRESOR_OXYGEN:
			return 0.45
		Game.Bonus.DETECTION_RANGE: # à faire
			return 0.3
		Game.Bonus.LIGHT: # à faire
			return 0.18
		Game.Bonus.ALERTE:
			return 0.45
		Game.Bonus.TRESOR_DETECTION:
			return 0.3

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
