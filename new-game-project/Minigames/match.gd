extends Control

@onready var buttons =  $GridContainer.get_children()
var checkingSame = false;
var curMatch;
var count: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(buttons.size()):
		buttons[i].set_meta("image_id", (i / 2))
		buttons[i].set_meta("matched", false)
	
	buttons.shuffle()

	for button in buttons:
		$GridContainer.remove_child(button)
		$GridContainer.add_child(button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func checkMatch(newMatch):
	if checkingSame == false:
		curMatch = newMatch
		curMatch.modulate = Color(1.4, 1.4, 1.4)
		checkingSame = true
	elif newMatch == curMatch:
		pass
	else:
		var curImageID = curMatch.get_meta("image_id")
		var newImageID = newMatch.get_meta("image_id")
		if curImageID == newImageID:
			curMatch.texture_normal = preload("res://temporaryImages/greySquare.png");
			newMatch.texture_normal = preload("res://temporaryImages/greySquare.png");
			curMatch.set_meta("matched", true)
			newMatch.set_meta("matched", true)
			curMatch.disabled = true
			newMatch.disabled = true
			count += 1
		if count == 8:
			$Label.text = "Won"
		curMatch.modulate = Color(1, 1, 1)
		curMatch = null
		checkingSame = false


func _on_button_1_pressed() -> void:
	checkMatch($GridContainer/Button1)

func _on_button_2_pressed() -> void:
	checkMatch($GridContainer/Button2)

func _on_button_3_pressed() -> void:
	checkMatch($GridContainer/Button3)

func _on_button_4_pressed() -> void:
	checkMatch($GridContainer/Button4)

func _on_button_5_pressed() -> void:
	checkMatch($GridContainer/Button5)

func _on_button_6_pressed() -> void:
	checkMatch($GridContainer/Button6)

func _on_button_7_pressed() -> void:
	checkMatch($GridContainer/Button7)

func _on_button_8_pressed() -> void:
	checkMatch($GridContainer/Button8)

func _on_button_9_pressed() -> void:
	checkMatch($GridContainer/Button9)

func _on_button_10_pressed() -> void:
	checkMatch($GridContainer/Button10)

func _on_button_11_pressed() -> void:
	checkMatch($GridContainer/Button11)

func _on_button_12_pressed() -> void:
	checkMatch($GridContainer/Button12)

func _on_button_13_pressed() -> void:
	checkMatch($GridContainer/Button13)

func _on_button_14_pressed() -> void:
	checkMatch($GridContainer/Button14)

func _on_button_15_pressed() -> void:
	checkMatch($GridContainer/Button15)

func _on_button_16_pressed() -> void:
	checkMatch($GridContainer/Button16)
