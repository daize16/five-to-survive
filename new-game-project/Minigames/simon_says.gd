extends Control

var simonSaysOrder = [0,0,0,0]
var round = 1
var butPress = 0
var pressButAllow
@onready var button1 = $GridContainer/Button1 
@onready var button2 = $GridContainer/Button2
@onready var button3 = $GridContainer/Button3 
@onready var button4 = $GridContainer/Button4 
@onready var label = $Label
@onready var label2 = $Label2
@onready var label3 = $Label3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressButAllow = false
	for x in range(0,4):
		simonSaysOrder[x] = randi_range(1,4)
	label.text = str(simonSaysOrder)
	playRound()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func playRound():
	await get_tree().create_timer(1.0).timeout
	if round == 5:
		label3.text = "Won!"
		return
	for x in range(0, round):
		pressButAllow = false
		var curButton = whichBut(x)
		curButton.modulate = Color(2, 2, 2, 1)
		await get_tree().create_timer(0.6).timeout
		curButton.modulate = Color(1,1,1,1)
		await get_tree().create_timer(0.5).timeout
	pressButAllow = true


func checkBut(butNum):
	if pressButAllow == false:
		return
	if simonSaysOrder[butPress] == butNum:
		butPress += 1
		if round == butPress:
			round += 1
			butPress = 0
			playRound()
	else:
		label3.text = "wrong!"
		round = 1
		butPress = 0
		playRound()


func whichBut(index):
	if simonSaysOrder[index] == 1:
		return button1
	elif simonSaysOrder[index] == 2:
		return button2
	elif simonSaysOrder[index] == 3:
		return button3
	else:
		return button4


func _on_button_1_pressed() -> void:
	checkBut(1)


func _on_button_2_pressed() -> void:
	checkBut(2)


func _on_button_3_pressed() -> void:
	checkBut(3)


func _on_button_4_pressed() -> void:
	checkBut(4)
