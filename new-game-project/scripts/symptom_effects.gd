extends Camera2D

@export var shakiness_enabled := false
@export var max_shake := 5.0
@export var start_at := 0.2

@onready var run_timer: Timer = $"../RunTimer"
@onready var cupboard_popup: CanvasLayer = $"../CupboardPopup"
@onready var nausea_tint: ColorRect = $"../HUD/NauseaTint"

func _process(_delta: float) -> void:
	var progress = 1.0 - run_timer.time_left / run_timer.wait_time
	var intensity = symptom_intensity(progress) #general variable i made to scale the effects customised over time!
	if nausea_tint.visible:
		nausea_tint.color.a = intensity * 0.28

	var shake_offset := Vector2.ZERO

	if shakiness_enabled:
		var shake_progress = maxf(progress - start_at, 0.0) / (1.0 - start_at)
		var gentle_shake = 0.22 * sqrt(shake_progress)
		var late_shake = 0.78 * pow(shake_progress, 5.0)
		var strength = (gentle_shake + late_shake) * max_shake
		shake_offset = Vector2(
			randf_range(-strength, strength),
			randf_range(-strength, strength)
		)

	offset = shake_offset
	cupboard_popup.offset = -shake_offset

func symptom_intensity(progress: float) -> float:
	# returns a general value to use for all symtpoms
	var seconds = progress * 300.0

	if seconds < 15.0:
		return 0.0
	if seconds < 30.0:
		var part = (seconds - 15.0) / 15.0
		return part * 0.25
	if seconds < 240.0:
		var part = (seconds - 30.0) / 210.0
		return 0.25 + part * 0.25

	var last_minute = (seconds - 240.0) / 60.0
	return 0.50 + last_minute * 0.50
