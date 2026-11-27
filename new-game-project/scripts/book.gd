extends CanvasLayer

const AILMENTS := [
	{
		"name": "Aloria",
		"symptoms": ["Shakiness", "Dizziness", "Fainting", "Twitching"],
		"cure": ["spider_silk", "bat_wings", "well_water", "shattered_mirror"]
	},
	{
		"name": "Crimson Pox",
		"symptoms": ["Vomiting", "Nausea", "Shakiness", "Dizziness"],
		"cure": ["shattered_mirror", "ghost_orchid", "eye_of_newt", "mushrooms"]
	},
	{
		"name": "Arsenic Poisoning",
		"symptoms": ["Nausea", "Vomiting", "Paranoia"],
		"cure": ["eye_of_newt", "bat_wings", "beeswax", "glow_worms"]
	},
	{
		"name": "Shiverrot",
		"symptoms": ["Twitching", "Freezing", "Weakness"],
		"cure": ["glow_worms", "beeswax", "crushed_beetles", "eye_of_newt"]
	},
	{
		"name": "Shadowlung",
		"symptoms": ["Vomiting", "Twitching", "Dizziness"],
		"cure": ["mushrooms", "bat_wings", "frozen_flame", "raven_feather"]
	},
	{
		"name": "Nightshade's Kiss",
		"symptoms": ["Hallucinations (lover)", "Fainting", "Blindness"],
		"cure": ["ghost_orchid", "widows_tears", "belladonna_berries", "frog_legs"]
	},
	{
		"name": "Withering Wart",
		"symptoms": ["Shakiness", "Twitching", "Overheating", "Fainting"],
		"cure": ["spider_silk", "mushrooms", "frog_legs", "raven_feather"]
	},
	{
		"name": "Wolfsbane's Bite",
		"symptoms": ["Nausea", "Hallucinations (wolf)", "Paranoia"],
		"cure": ["bat_wings", "well_water", "widows_tears", "frozen_flame"]
	},
	{
		"name": "Banshee's Breath",
		"symptoms": ["Paranoia", "Hallucinations (ghosts)", "Blindness", "Weakness"],
		"cure": ["frozen_flame", "grave_moss", "mushrooms", "well_water"]
	},
	{
		"name": "Foxglove Fever",
		"symptoms": ["Overheating", "Freezing", "Weakness", "Fainting"],
		"cure": ["frozen_flame", "well_water", "spider_silk", "eye_of_newt"]
	},
	{
		"name": "Hollow Heart",
		"symptoms": ["Fainting", "Sloth", "Blindness", "Overheating"],
		"cure": ["widows_tears", "spider_silk", "crushed_beetles", "grave_moss"]
	},
	{
		"name": "Necrosis of the Night",
		"symptoms": ["Vomiting", "Sloth", "Blindness", "Fainting"],
		"cure": ["grave_moss", "bat_wings", "belladonna_berries", "crushed_beetles"]
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

	var cure_names = []
	for ingredient_id in ailment["cure"]:
		cure_names.append(IngredientDB.display_name(ingredient_id))

	cure_text.text = "• " + "\n• ".join(cure_names)
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
