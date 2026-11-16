extends Node2D

@onready var popup = $CupboardPopup

func _ready() -> void:
	var ids: Array = []
	for c in get_tree().get_nodes_in_group("cupboards"):
		ids.append(c.cupboard_id)
		c.opened.connect(popup.open_for)
	GameState.new_run(ids)          # later: pass the antidote's ingredients as 2nd argument

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()   # reloading runs _ready, so contents re-randomise
