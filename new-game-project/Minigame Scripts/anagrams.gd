extends Control

var word_bank = ["WITCH", "ORACLE", "CANDLE", "ZOMBIE", "CREEPY", "SPIDERWEB", "GRAVEYARD", "POLTERGEIST", "GARGOYLE"]
var chosen_word = ""
var scrambled_word = ""
@onready var label = $ColorRect/Word
@onready var submitMessage = $ColorRect/Label
@onready var answer_input = $ColorRect/InputText

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chosen_word = word_bank.pick_random()
	scrambled_word = scramble_word(chosen_word)
	label.text = scrambled_word

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ENTER):
		_on_button_pressed()

func scramble_word(word: String) -> String:
	var letters = Array(word.split("", false))
	letters.shuffle()
	return "".join(letters)

func _on_button_pressed() -> void:
	var playerAnswer = answer_input.text
	if playerAnswer.to_upper() == chosen_word:
		submitMessage.text = "Correct!"
	else:
		submitMessage.text = "Wrong!"
		await get_tree().create_timer(1.0).timeout
		submitMessage.text = ""
