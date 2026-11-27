extends Node2D

@onready var popup = $CupboardPopup
@onready var cupboards_root: Node2D = $Cupboard

func _ready() -> void:
	var ids: Array = []
	for c: Cupboard in get_tree().get_nodes_in_group("cupboards"):
		ids.append(c.cupboard_id)
		c.opened.connect(popup.open_for)
	GameState.new_run(ids)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
