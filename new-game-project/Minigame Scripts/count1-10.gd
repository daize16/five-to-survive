extends Control

var numArray: Array = ["1","2","3","4","5","6","7","8","9","10"]
var count: int = 1
@onready var button1 = $GridContainer/Button1 
@onready var button2 = $GridContainer/Button2
@onready var button3 = $GridContainer/Button3 
@onready var button4 = $GridContainer/Button4 
@onready var button5 = $GridContainer/Button5 
@onready var button6 = $GridContainer/Button6 
@onready var button7 = $GridContainer/Button7 
@onready var button8 = $GridContainer/Button8 
@onready var button9 = $GridContainer/Button9 
@onready var button10 = $GridContainer/Button10 
@onready var winLabel = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	numArray.shuffle()
	button1.text = numArray[0]
	button2.text = numArray[1]
	button3.text = numArray[2]
	button4.text = numArray[3]
	button5.text = numArray[4]
	button6.text = numArray[5]
	button7.text = numArray[6]
	button8.text = numArray[7]
	button9.text = numArray[8]
	button10.text = numArray[9]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func check_button(button):
	if button.text == str(count):
		count += 1
		button.modulate = Color(0.482, 1, 0.5, 1.0)
	else:
		count = 1
		button.modulate = Color(1.0, 0.531, 0.466, 1.0)
		await get_tree().create_timer(1.0).timeout
		button1.modulate = Color.WHITE
		button2.modulate = Color.WHITE
		button3.modulate = Color.WHITE
		button4.modulate = Color.WHITE
		button5.modulate = Color.WHITE
		button6.modulate = Color.WHITE
		button7.modulate = Color.WHITE
		button8.modulate = Color.WHITE
		button9.modulate = Color.WHITE
		button10.modulate = Color.WHITE
		count = 1
		
	if count == 11:
		winLabel.text = "Won!"


func _on_button_1_pressed() -> void:
	check_button(button1)

func _on_button_2_pressed() -> void:
	check_button(button2)

func _on_button_3_pressed() -> void:
	check_button(button3)

func _on_button_4_pressed() -> void:
	check_button(button4)

func _on_button_5_pressed() -> void:
	check_button(button5)

func _on_button_6_pressed() -> void:
	check_button(button6)

func _on_button_7_pressed() -> void:
	check_button(button7)

func _on_button_8_pressed() -> void:
	check_button(button8)

func _on_button_9_pressed() -> void:
	check_button(button9)

func _on_button_10_pressed() -> void:
	check_button(button10)
