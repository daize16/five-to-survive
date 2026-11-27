extends CanvasLayer

@onready var slot: TextureRect = $ItemSlot

func _ready() -> void:
	GameState.held_changed.connect(_update)
	_update("")

func _update(id: String) -> void:
	slot.texture = IngredientDB.get_texture(id) if id != "" else null

func _process(_delta: float) -> void:
	var timer = get_node_or_null("../RunTimer") as Timer
	if timer == null or timer.is_stopped():
		return

	var seconds_left = ceili(timer.time_left)
	var minutes = floori(seconds_left / 60.0)
	var seconds = seconds_left % 60
	var seconds_text = str(seconds)

	if seconds < 10:
		seconds_text = "0" + seconds_text

	$CountdownLabel.text = str(minutes) + ":" + seconds_text
