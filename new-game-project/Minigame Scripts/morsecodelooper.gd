extends Control

@onready var flasher = $Light/Sprite2D
@onready var answer_input = $InputText
@onready var submitMessage = $Label
var word_bank = [
	"ORACLE", "CANDLE", "ZOMBIE", "CREEPY", "SPIDER",
	"SHADOW", "WRAITH", "CURSED", "RIDDLE", "MYSTIC",
	"CIPHER", "SPELLS", "WITCHY"
]

var code_bank = [
	"---/.-./.-/-.-./.-../.", #oracle
	"-.-./.-/-/-.../.-../.", #candle
	"--../---/--/-.../../.", #zombie
	"-.-./.-./././.--./-.--", #creepy
	".../.--./../-.././.-.", #spider
	".../..../.-/-../---/.--", #shadow
	".--/.-./.-/../-/....", #wraith
	"-.-./..-/.-./..././-..", #cursed
	".-./../-../-../.-../.", #riddle
	"--/-.--/.../-/../-.-.", #mystic
	"-.-./../.--./...././.-.", #cipher
	".../.--././.-../.-../...", #spells
	".--/../-/-.-./..../-.--" #witchy
]

var chosen_word
var chosen_morse
var playing = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var randomInt = randi_range(0, code_bank.size()-1)
	print(word_bank[randomInt])
	chosen_word = word_bank[randomInt]
	print(code_bank[randomInt])
	chosen_morse = code_bank[randomInt]
	flashMorse()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func flashMorse():
	await get_tree().create_timer(2).timeout
	while playing == true:
		for letter in chosen_morse:
			if playing == false:
				break
			if letter == '.':
				flasher.modulate = Color(1.8,1.8,1.8)
				await get_tree().create_timer(0.3).timeout
				flasher.modulate = Color(1,1,1,1)
			elif letter == '-':
				flasher.modulate = Color(1.8,1.8,1.8)
				await get_tree().create_timer(0.8).timeout
				flasher.modulate = Color(1,1,1,1)
			else:
				await get_tree().create_timer(1).timeout
			await get_tree().create_timer(0.3).timeout
		await get_tree().create_timer(1).timeout


func _on_button_pressed() -> void:
	var playerAnswer = answer_input.text
	if playerAnswer.to_upper() == chosen_word:
		submitMessage.text = "Correct!"
		playing = false
	else:
		submitMessage.text = "Wrong!"
		await get_tree().create_timer(1.0).timeout
		submitMessage.text = ""
