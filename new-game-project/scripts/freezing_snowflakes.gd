extends Control

@export var snowflake_scene: PackedScene
@export var slow_interval := 4.5
@export var fast_interval := 0.8

var spawn_interval := 4.5

@onready var timer: Timer = $SpawnTimer


func update_freezing(active: bool, intensity: float) -> void:
	# colder = flakes show up more often
	var range_size = slow_interval - fast_interval
	spawn_interval = slow_interval - range_size * intensity

	var should_show = active and intensity > 0.0
	if should_show == visible:
		return

	visible = should_show
	if should_show:
		timer.start(spawn_interval)
	else:
		timer.stop()
		clear_flakes()


func clear_flakes() -> void:
	for child in get_children():
		if child is TextureRect:
			child.queue_free()


func _on_spawn_timer_timeout() -> void:
	var flake = snowflake_scene.instantiate()

	# keep the whole flake on screen
	var max_x = max(0, size.x - flake.size.x)
	var max_y = max(0, size.y - flake.size.y)
	flake.position = Vector2(randf_range(0, max_x), randf_range(0, max_y)).round()

	add_child(flake)
	timer.start(spawn_interval)
