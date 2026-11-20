extends Node


#code for shakiness symptom that gets worse over time
#whoever is doing the game loop pls can u use this var below make it true when this symptom is needed

@export var shakiness_enabled := false

var shakiness_time := 0.0
var original_position := Vector2.ZERO
var world: Node2D

func _ready() -> void:
	world = get_parent() as Node2D
	original_position = world.position

func _process(delta: float) -> void:
	if shakiness_enabled:
		shakiness_time += delta
		var progress = min(shakiness_time / 300.0, 1.0)
		var intensity = progress * progress * progress
		var shake = int(1 + intensity * 7)
		world.position = original_position + Vector2(
			randi_range(-shake, shake),
			randi_range(-shake, shake)
		)
	else:
		shakiness_time = 0.0
		world.position = original_position
