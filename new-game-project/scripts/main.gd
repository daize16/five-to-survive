extends Node2D

@onready var popup = $CupboardPopup
@onready var book = $Book
@onready var symptom_effects = $SymptomEffects

var current_illness: Dictionary = {}
var cupboard_ids: Array = []

func _ready() -> void:
	for c: Cupboard in get_tree().get_nodes_in_group("cupboards"):
		cupboard_ids.append(c.cupboard_id)
		c.opened.connect(popup.open_for)
	start_game()

func start_game() -> void:
	current_illness = book.sorted_ailments.pick_random()
	print("Illness: ", current_illness["name"])
	GameState.new_run(cupboard_ids, current_illness["cure"])
	start_symptoms(current_illness["symptoms"])

func start_symptoms(symptoms: Array) -> void:
	symptom_effects.shakiness_enabled = symptoms.has("Shakiness")
	# Add the other symptom checks here when their effects are ready.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
