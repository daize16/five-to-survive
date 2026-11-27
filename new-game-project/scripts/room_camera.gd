extends Camera2D

const SCREEN := Vector2(480, 270)

@onready var target: Node2D = $"../Player"
var _room := -1

func _ready() -> void:
	position_smoothing_enabled = false
	_snap(_room_of(target.global_position.x), false)

func _process(_delta: float) -> void:
	var room := _room_of(target.global_position.x)
	if room != _room:
		_snap(room, true)

func _room_of(x: float) -> int:
	return maxi(0, int(floor(x / SCREEN.x)))

func _snap(room: int, slide: bool) -> void:
	_room = room
	var dest := Vector2(room * SCREEN.x + SCREEN.x / 2.0, SCREEN.y / 2.0)
	if slide:
		create_tween().tween_property(self, "global_position", dest, 0.25)
	else:
		global_position = dest