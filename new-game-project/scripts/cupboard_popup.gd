extends CanvasLayer

const SCALE := 2                         # popup art and ingredients are shown at x2
const POPUP_ART := "res://assets/cupboards/cupboard_%s_popup.png"

@onready var stage: Control = $Stage
@onready var name_label: Label = $NameLabel
@onready var hint: Label = $Hint

var _cupboard: Cupboard

func _ready() -> void:
	hide()

func open_for(cupboard: Cupboard) -> void:
	_cupboard = cupboard
	_rebuild()
	show()
	get_tree().paused = true             # freezes the player while it's open

func close() -> void:
	hide()
	get_tree().paused = false

func _rebuild() -> void:
	for child in stage.get_children():
		child.queue_free()
	name_label.text = ""

	var vp: Vector2 = get_viewport().get_visible_rect().size
	var art: Texture2D = load(POPUP_ART % _cupboard.variant)
	var art_size := Vector2(art.get_size()) * SCALE

	# Centre the open cupboard on screen
	stage.size = art_size
	stage.position = ((vp - art_size) / 2.0).round()

	var bg := TextureRect.new()
	bg.texture = art
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.size = art_size
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(bg)

	# Labels under the cupboard
	name_label.custom_minimum_size = Vector2(art_size.x, 16)
	name_label.size = Vector2(art_size.x, 16)
	name_label.position = stage.position + Vector2(0, art_size.y + 4)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.size = Vector2(vp.x, 16)
	hint.position = Vector2(0, vp.y - 20)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	# Place this cupboard's ingredients into its shelf slots
	var ids: Array = GameState.contents[_cupboard.cupboard_id]
	var slots: Array = Cupboard.VARIANTS[_cupboard.variant]["slots"]
	if ids.is_empty():
		name_label.text = "Empty."
		return

	for i in mini(ids.size(), slots.size()):
		var id: String = ids[i]
		var btn := TextureButton.new()
		btn.texture_normal = IngredientDB.get_texture(id)
		btn.ignore_texture_size = true
		btn.stretch_mode = TextureButton.STRETCH_SCALE
		btn.custom_minimum_size = Vector2(16, 16) * SCALE
		btn.size = Vector2(16, 16) * SCALE
		btn.position = slots[i] * SCALE
		btn.pressed.connect(_on_item_pressed.bind(id))
		btn.mouse_entered.connect(func():
			btn.modulate = Color(1.3, 1.3, 1.3)
			name_label.text = IngredientDB.display_name(id))
		btn.mouse_exited.connect(func():
			btn.modulate = Color.WHITE
			name_label.text = "")
		stage.add_child(btn)

func _on_item_pressed(id: String) -> void:
	if GameState.take_item(_cupboard.cupboard_id, id):
		close()
	else:
		name_label.text = "Your hands are full."

func _unhandled_input(event: InputEvent) -> void:
	if visible and (event.is_action_pressed("ui_cancel") or event.is_action_pressed("interact")):
		close()
		get_viewport().set_input_as_handled()
