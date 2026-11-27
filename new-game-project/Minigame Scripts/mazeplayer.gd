extends CharacterBody2D


@export var speed: float = 75.0
const JUMP_VELOCITY = -400.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var last_direction: String = "walk_right"



func _physics_process(delta: float) -> void:
	var direction = Input.get_vector(
		"walk_left",
		"walk_right",
		"walk_up",
		"walk_down"
	)
	
	if direction.x < 0:
		last_direction = "walk_left"
	elif direction.x > 0:
		last_direction = "walk_right"
	if direction != Vector2.ZERO:
		sprite.play(last_direction)
	else:
		sprite.stop()

	
	velocity = direction * speed

	move_and_slide()
	
	if get_slide_collision_count() > 0:
		print(get_slide_collision(0).get_collider())
