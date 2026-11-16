extends CanvasLayer

@onready var slot: TextureRect = $ItemSlot

func _ready() -> void:
	GameState.held_changed.connect(_update)
	_update("")

func _update(id: String) -> void:
	slot.texture = IngredientDB.get_texture(id) if id != "" else null
