extends Node2D

const CUPBOARD_SCENE := preload("res://cupboard.tscn")

# Position = the cupboard's feet (bottom centre)
const LAYOUT := [
	{"id": "cupboard_1", "variant": "cabinet",  "pos": Vector2(64, 44)},
	{"id": "cupboard_2", "variant": "dresser",  "pos": Vector2(160, 44)},
	{"id": "cupboard_3", "variant": "wardrobe", "pos": Vector2(32, 128)},
	{"id": "cupboard_4", "variant": "cabinet",  "pos": Vector2(448, 200)},
]

@onready var popup = $CupboardPopup
@onready var cupboards_root: Node2D = $Cupboards

func _ready() -> void:
	for entry in LAYOUT:
		var c: Cupboard = CUPBOARD_SCENE.instantiate()
		c.cupboard_id = entry["id"]
		c.variant = entry["variant"]       # set before add_child so _ready sees it
		c.position = entry["pos"]
		cupboards_root.add_child(c)

	var ids: Array = []
	for c in get_tree().get_nodes_in_group("cupboards"):
		ids.append(c.cupboard_id)
		c.opened.connect(popup.open_for)
	GameState.new_run(ids)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()