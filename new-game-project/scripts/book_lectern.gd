extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var hover_label: Label = $HoverLabel
@onready var proximity_zone: Area2D = $ProximityZone

var _player_near := false
var _is_hovered := false

func _ready() -> void:
	input_pickable = true
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)
	proximity_zone.body_entered.connect(_on_proximity_body_entered)
	proximity_zone.body_exited.connect(_on_proximity_body_exited)
	hover_label.hide()

func _on_mouse_entered() -> void:
	_is_hovered = true
	_update_hover()

func _on_mouse_exited() -> void:
	_is_hovered = false
	_update_hover()

func _on_proximity_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_near = true
		_update_hover()

func _on_proximity_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_near = false
		_update_hover()

func _update_hover() -> void:
	hover_label.visible = _is_hovered or _player_near
	hover_label.text = "Reference Book\nE / click to read" if _player_near else "Reference Book\nWalk closer"
	if _is_hovered and _player_near:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		sprite.modulate = Color("fff0ce")
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		sprite.modulate = Color.WHITE

func try_read_book() -> bool:
	if not _player_near:
		return false
	get_tree().call_group("book_ui", "open_book")
	return true

func _on_input_event(_viewport: Viewport, event: InputEvent, _shape_index: int) -> void:
	if (event is InputEventMouseButton and event.pressed
			and event.button_index == MOUSE_BUTTON_LEFT):
		try_read_book()
		get_viewport().set_input_as_handled()
