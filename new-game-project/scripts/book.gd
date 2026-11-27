extends CanvasLayer

const AILMENTS := [
	{
		"name": "Aloria",
		"symptoms": ["Shakiness", "Dizziness", "Fainting", "Twitching"],
		"cure": ["Spider silk", "Bat wings", "Well water", "Shattered mirror"]
	},
	{
		"name": "Crimson Pox",
		"symptoms": ["Vomiting", "Nausea", "Shakiness", "Dizziness"],
		"cure": ["Shattered mirror", "Ghost orchid", "Eye of newt", "Mushrooms"]
	},
	{
		"name": "Arsenic Poisoning",
		"symptoms": ["Nausea", "Vomiting", "Paranoia"],
		"cure": ["Eye of newt", "Bat wings", "Beeswax", "Glow worms"]
	},
	{
		"name": "Shiverrot",
		"symptoms": ["Twitching", "Freezing", "Weakness"],
		"cure": ["Glow worms", "Beeswax", "Crushed beetles", "Eye of newt"]
	},
	{
		"name": "Shadowlung",
		"symptoms": ["Vomiting", "Twitching", "Dizziness"],
		"cure": ["Mushrooms", "Bat wings", "Frozen flame", "Raven feather"]
	},
	{
		"name": "Nightshade's Kiss",
		"symptoms": ["Hallucinations (lover)", "Fainting", "Blindness"],
		"cure": ["Ghost orchid", "Tears of a widow", "Belladonna berries", "Frog legs"]
	},
	{
		"name": "Withering Wart",
		"symptoms": ["Shakiness", "Twitching", "Overheating", "Fainting"],
		"cure": ["Spider silk", "Mushrooms", "Frog legs", "Raven feather"]
	},
	{
		"name": "Wolfsbane's Bite",
		"symptoms": ["Nausea", "Hallucinations (wolf)", "Paranoia"],
		"cure": ["Bat wings", "Well water", "Tears of a widow", "Frozen flame"]
	},
	{
		"name": "Banshee's Breath",
		"symptoms": ["Paranoia", "Hallucinations (ghosts)", "Blindness", "Weakness"],
		"cure": ["Frozen flame", "Gravemoss", "Mushrooms", "Well water"]
	},
	{
		"name": "Foxglove Fever",
		"symptoms": ["Overheating", "Freezing", "Weakness", "Fainting"],
		"cure": ["Frozen flame", "Well water", "Spider silk", "Eye of newt"]
	},
	{
		"name": "Hollow Heart",
		"symptoms": ["Fainting", "Sloth", "Blindness", "Overheating"],
		"cure": ["Tears of a widow", "Spider silk", "Crushed beetles", "Gravemoss"]
	},
	{
		"name": "Necrosis of the Night",
		"symptoms": ["Vomiting", "Sloth", "Blindness", "Fainting"],
		"cure": ["Gravemoss", "Bat wings", "Belladonna berries", "Crushed beetles"]
	}
]

const FIRST_AILMENT_PAGE = 3

var sorted_ailments = []
var current_ailment_index = -1

@onready var overlay = $Overlay
@onready var left_header = $Overlay/BookSpread/LeftPage/LeftMargin/LeftLayout/LeftHeader
@onready var index_left = $Overlay/BookSpread/LeftPage/LeftMargin/LeftLayout/IndexColumnLeft
@onready var symptoms_text = $Overlay/BookSpread/LeftPage/LeftMargin/LeftLayout/SymptomsText
@onready var ailment_title = $Overlay/BookSpread/RightPage/RightMargin/RightLayout/RightHeader/AilmentTitle
@onready var index_right = $Overlay/BookSpread/RightPage/RightMargin/RightLayout/IndexColumnRight
@onready var cure_heading = $Overlay/BookSpread/RightPage/RightMargin/RightLayout/CureHeading
@onready var cure_text = $Overlay/BookSpread/RightPage/RightMargin/RightLayout/CureText
@onready var left_page_number = $Overlay/BookSpread/LeftPage/LeftMargin/LeftLayout/LeftPageNumber
@onready var right_page_number = $Overlay/BookSpread/RightPage/RightMargin/RightLayout/RightPageNumber
@onready var close_button = $Overlay/BookSpread/RightPage/RightMargin/RightLayout/RightHeader/CloseButton
@onready var previous_button = $Overlay/BookSpread/PreviousButton
@onready var next_button = $Overlay/BookSpread/NextButton

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("book_ui")

	sorted_ailments = AILMENTS.duplicate()
	sorted_ailments.sort_custom(func(a, b): return a["name"] < b["name"])

	fill_index(index_left, 0)
	fill_index(index_right, 6)

	previous_button.pressed.connect(previous_page)
	next_button.pressed.connect(next_page)
	close_button.pressed.connect(close_book)

	show_index()
	overlay.hide()


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and overlay.visible:
		close_book()
		get_viewport().set_input_as_handled()


func fill_index(column, start):
	for i in range(start, min(start + 6, sorted_ailments.size())):
		var row = HBoxContainer.new()

		var name_label = Label.new()
		name_label.text = sorted_ailments[i]["name"]
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var page_label = Label.new()
		page_label.text = "p. %02d" % (FIRST_AILMENT_PAGE + i * 2)

		row.add_child(name_label)
		row.add_child(page_label)
		column.add_child(row)


func show_index():
	current_ailment_index = -1

	left_header.text = "BOOK OF COMMON AILMENTS"
	ailment_title.text = "INDEX • CONTINUED"

	index_left.show()
	index_right.show()
	symptoms_text.hide()
	cure_heading.hide()
	cure_text.hide()

	left_page_number.text = "— 01 —"
	right_page_number.text = "— 02 —"

	previous_button.disabled = true
	next_button.disabled = false


func show_ailment(index):
	current_ailment_index = index
	var ailment = sorted_ailments[index]

	index_left.hide()
	index_right.hide()

	left_header.text = "SYMPTOMS"
	symptoms_text.text = "• " + "\n• ".join(ailment["symptoms"])
	symptoms_text.show()

	ailment_title.text = ailment["name"]
	cure_heading.text = "CURE INGREDIENTS"
	cure_heading.show()
	cure_text.text = "• " + "\n• ".join(ailment["cure"])
	cure_text.show()

	var page = FIRST_AILMENT_PAGE + index * 2
	left_page_number.text = "— %02d —" % page
	right_page_number.text = "— %02d —" % (page + 1)

	previous_button.disabled = false
	next_button.disabled = index == sorted_ailments.size() - 1


func previous_page():
	if current_ailment_index == 0:
		show_index()
	elif current_ailment_index > 0:
		show_ailment(current_ailment_index - 1)


func next_page():
	if current_ailment_index == -1:
		show_ailment(0)
	elif current_ailment_index < sorted_ailments.size() - 1:
		show_ailment(current_ailment_index + 1)


func open_book():
	if overlay.visible:
		return

	var cupboard = get_parent().get_node_or_null("CupboardPopup")
	if cupboard and cupboard.visible:
		cupboard.close()

	show_index()
	overlay.show()
	get_tree().paused = true


func close_book():
	overlay.hide()
	get_tree().paused = false
