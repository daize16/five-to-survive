extends Control

var count = 0
@onready var thorn1 = $Node2D/Thorn1
@onready var thorn2 = $Node2D/Thorn2
@onready var thorn3 = $Node2D/Thorn3
@onready var thorn4 = $Node2D/Thorn4
@onready var thorn5 = $Node2D/Thorn5
@onready var thorn6 = $Node2D/Thorn6
@onready var thorn7 = $Node2D/Thorn7
@onready var thorn8 = $Node2D/Thorn8
@onready var thorn9 = $Node2D/Thorn9
@onready var thorn10 = $Node2D/Thorn10
@onready var thorn11 = $Node2D/Thorn11
@onready var thorn12 = $Node2D/Thorn12
@onready var label = $Label
@onready var thorns = [thorn1, thorn2, thorn3, thorn4, thorn5, thorn6, thorn7, thorn8, thorn9, thorn10, thorn11, thorn12]
@onready var visibleThorns = randi_range(8,10)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	thorns.shuffle()
	for x in range(thorns.size()):
		var curThorn = thorns[x]
		if x > visibleThorns:
			curThorn.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func removeThorn(event, thorn):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			thorn.hide()
			count += 1
	if count > visibleThorns:
		label.text = "Won!"

func _on_thorn_1_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	removeThorn(event, thorn1)

func _on_thorn_2_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	removeThorn(event, thorn2)

func _on_thorn_3_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	removeThorn(event, thorn3)

func _on_thorn_4_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	removeThorn(event, thorn4)

func _on_thorn_5_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	removeThorn(event, thorn5)

func _on_thorn_6_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	removeThorn(event, thorn6)

func _on_thorn_7_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	removeThorn(event, thorn7)

func _on_thorn_8_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	removeThorn(event, thorn8)

func _on_thorn_9_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	removeThorn(event, thorn9)

func _on_thorn_10_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	removeThorn(event, thorn10)

func _on_thorn_11_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	removeThorn(event, thorn11)

func _on_thorn_12_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	removeThorn(event, thorn12)

func _on_thorn_1_mouse_entered() -> void:
	thorn1.modulate = Color(1.5, 1.5, 1.2)

func _on_thorn_1_mouse_exited() -> void:
	thorn1.modulate = Color(1, 1, 1)

func _on_thorn_2_mouse_entered() -> void:
	thorn2.modulate = Color(1.5, 1.5, 1.2)

func _on_thorn_2_mouse_exited() -> void:
	thorn2.modulate = Color(1, 1, 1)

func _on_thorn_3_mouse_entered() -> void:
	thorn3.modulate = Color(1.5, 1.5, 1.2)

func _on_thorn_3_mouse_exited() -> void:
	thorn3.modulate = Color(1, 1, 1)

func _on_thorn_4_mouse_entered() -> void:
	thorn4.modulate = Color(1.5, 1.5, 1.2)

func _on_thorn_4_mouse_exited() -> void:
	thorn4.modulate = Color(1, 1, 1)

func _on_thorn_5_mouse_entered() -> void:
	thorn5.modulate = Color(1.5, 1.5, 1.2)

func _on_thorn_5_mouse_exited() -> void:
	thorn5.modulate = Color(1, 1, 1)

func _on_thorn_6_mouse_entered() -> void:
	thorn6.modulate = Color(1.5, 1.5, 1.2)

func _on_thorn_6_mouse_exited() -> void:
	thorn6.modulate = Color(1, 1, 1)

func _on_thorn_7_mouse_entered() -> void:
	thorn7.modulate = Color(1.5, 1.5, 1.2)

func _on_thorn_7_mouse_exited() -> void:
	thorn7.modulate = Color(1, 1, 1)

func _on_thorn_8_mouse_entered() -> void:
	thorn8.modulate = Color(1.5, 1.5, 1.2)

func _on_thorn_8_mouse_exited() -> void:
	thorn8.modulate = Color(1, 1, 1)

func _on_thorn_9_mouse_entered() -> void:
	thorn9.modulate = Color(1.5, 1.5, 1.2)

func _on_thorn_9_mouse_exited() -> void:
	thorn9.modulate = Color(1, 1, 1)

func _on_thorn_10_mouse_entered() -> void:
	thorn10.modulate = Color(1.5, 1.5, 1.2)

func _on_thorn_10_mouse_exited() -> void:
	thorn10.modulate = Color(1, 1, 1)

func _on_thorn_11_mouse_entered() -> void:
	thorn11.modulate = Color(1.5, 1.5, 1.2)

func _on_thorn_11_mouse_exited() -> void:
	thorn11.modulate = Color(1, 1, 1)

func _on_thorn_12_mouse_entered() -> void:
	thorn12.modulate = Color(1.5, 1.5, 1.2)

func _on_thorn_12_mouse_exited() -> void:
	thorn12.modulate = Color(1, 1, 1)
