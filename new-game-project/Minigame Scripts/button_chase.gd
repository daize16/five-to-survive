extends Control

@onready var buttonToChase = $ColorRect/ButtonChased
@onready var progressBar = $ProgressBar
@onready var resultLabel = $Label
var clicksNeeded = 10
var clicksAt = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progressBar.value = 0
	move_button()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_chased_pressed() -> void:
	clicksAt += 1
	progressBar.value = float(clicksAt) / clicksNeeded * 100
	if clicksAt < clicksNeeded:
		move_button()
	else:
		resultLabel.text = "Won!"


func move_button() -> void:
	var screen_size = $ColorRect.size
	var button_size = buttonToChase.size
	
	var random_x = randf_range(0, screen_size.x - button_size.x)
	var random_y = randf_range(0, screen_size.y - button_size.y)

	buttonToChase.position = Vector2(random_x, random_y)
