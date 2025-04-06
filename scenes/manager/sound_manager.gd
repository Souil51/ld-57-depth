extends Node2D

@export var texture_on: Texture2D
@export var texture_off: Texture2D

var _music_enabled: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		_music_enabled = !_music_enabled
		
		if _music_enabled:
			$Sprite2D.texture = texture_on
			Game.enable_music.emit()
		else:
			$Sprite2D.texture = texture_off
			Game.disable_music.emit()
