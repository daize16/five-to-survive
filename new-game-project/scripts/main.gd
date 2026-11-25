extends Node2D



@onready var popup = $CupboardPopup
@onready var book = $Book
@onready var symptom_effects = $SymptomEffects

var run_state = "ready"
var current_illness: Dictionary = {}
var cupboard_ids: Array = []
var added_ingredients: Array = []

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
	run_state = "playing"
	$RunTimer.start()
	added_ingredients.clear()

func start_symptoms(symptoms: Array) -> void:
	symptom_effects.shakiness_enabled = symptoms.has("Shakiness")
	# Add the other symptom checks here when their effects are ready.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		return

	if run_state != "playing":
		return
	if not $Actors/CauldronArea.overlaps_body($Actors/Player):
		return

	var use_cauldron = event.is_action_pressed("interact")
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var cauldron = $Actors/Cauldron
		use_cauldron = cauldron.is_pixel_opaque(cauldron.get_local_mouse_position())

	if use_cauldron:
		get_viewport().set_input_as_handled()
		add_to_cauldron()

func finish_run(won: bool) -> void:
	if run_state != "playing":
		return

	$RunTimer.stop()
	start_symptoms([])
	position = symptom_effects.original_position

	var result_label = $ResultUI/ResultPanel/ResultLabel

	if won:
		run_state = "won"
		result_label.text = "You made the antidote!"
	else:
		run_state = "lost"
		result_label.text = "Time ran out :("

	if book.overlay.visible:
		book.close_book()

	if popup.visible:
		popup.close()

	$ResultUI/ResultPanel.show()
	get_tree().paused = true

func _on_run_timer_timeout() -> void:
	$HUD/CountdownLabel.text = "0:00"
	finish_run(false)


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func add_to_cauldron() -> void:
	var brew_label = $HUD/BrewLabel

	if GameState.held_item == "":
		brew_label.text = "Bring an ingredient first."
		return

	var ingredient = GameState.use_held_item()
	var recipe = current_illness["cure"]

	if not recipe.has(ingredient) or added_ingredients.has(ingredient):
		brew_label.text = "That ingredient didn't help..."
		return

	added_ingredients.append(ingredient)
	brew_label.text = "The potion bubbles!"

	if added_ingredients.size() == recipe.size():
		finish_run(true)
