class_name Cupboard
extends StaticBody2D

signal opened(cupboard: Cupboard)

const ART := "res://assets/cupboards/cupboard_%s_%s.png"
const FOOT_H := 12.0

const VARIANTS := {
	"cabinet":  {"size": Vector2(32, 32), "slots": [Vector2(14, 12), Vector2(50, 12), Vector2(32, 36)]},
	"dresser":  {"size": Vector2(32, 32), "slots": [Vector2(8, 18), Vector2(31, 18), Vector2(54, 18)]},
	"wardrobe": {"size": Vector2(32, 48), "slots": [Vector2(50, 20), Vector2(50, 48), Vector2(18, 72)]},
}

@export_enum("cabinet", "dresser", "wardrobe") var variant: String = "cabinet"
@export var cupboard_id := "cupboard_1"
@export var require_nearby := false   # true = player must be close to click

var is_open := false
var _player_near := false

@onready var sprite: Sprite2D = $Sprite2D
@onready var prompt: Label = $Prompt
@onready var body_shape: CollisionShape2D = $CollisionShape2D
@onready var zone: Area2D = $InteractArea
@onready var zone_shape: CollisionShape2D = $InteractArea/CollisionShape2D

func _ready() -> void:
	add_to_group("cupboards")
	var size: Vector2 = VARIANTS[variant]["size"]

	sprite.centered = false
	sprite.position = Vector2(-size.x / 2.0, -size.y)

	var solid := RectangleShape2D.new()
	solid.size = Vector2(size.x, FOOT_H)
	body_shape.shape = solid
	body_shape.position = Vector2(0, -FOOT_H / 2.0)

	var area := RectangleShape2D.new()
	area.size = Vector2(size.x + 24, 48)
	zone_shape.shape = area
	zone_shape.position = Vector2.ZERO

	prompt.text = "E / click: open"
	prompt.position = Vector2(-40, -size.y - 14)
	prompt.hide()

	_update_sprite()
	zone.body_entered.connect(_on_body_entered)
	zone.body_exited.connect(_on_body_exited)

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.pressed
			and event.button_index == MOUSE_BUTTON_LEFT):
		return
	if require_nearby and not _player_near:
		return
	if is_open:
		return
	if sprite.get_rect().has_point(sprite.get_local_mouse_position()):
		get_viewport().set_input_as_handled()
		interact()

func _update_sprite() -> void:
	sprite.texture = load(ART % [variant, "open" if is_open else "closed"])

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.nearby = self
		_player_near = true
		prompt.show()

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player") and body.nearby == self:
		body.nearby = null
		_player_near = false
		prompt.hide()

func interact() -> void:
	is_open = true
	_update_sprite()
	opened.emit(self)
	get_tree().call_group("cupboard_popup", "open_for", self)
