extends CharacterBody2D

@export var speed: float = 100.0
var symptom_speed_multiplier := 1.0
var screen_size: Vector2
var facing := "right"
var nearby: Cupboard = null

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("player")
	screen_size = get_viewport_rect().size

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and nearby:
		get_viewport().set_input_as_handled()
		nearby.interact()

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")

	if direction != Vector2.ZERO:
		if abs(direction.x) >= abs(direction.y):
			facing = "right" if direction.x > 0 else "left"
		else:
			facing = "down" if direction.y > 0 else "up"
		sprite.play("walk_" + facing)
	else:
		sprite.stop()

	velocity = direction * speed * symptom_speed_multiplier
	move_and_slide()

	position = position.clamp(Vector2.ZERO, screen_size)
