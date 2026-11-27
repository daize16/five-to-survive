extends Control

@onready var grid: GridContainer = $Puzzleboard/GridContainer
@onready var boardbackground = $Puzzleboard/BoardBackground
@onready var label = $Label

@export var puzzleImage: Texture2D
var imageToSwap: TextureButton = null


func _ready() -> void:
	create_puzzle()

func create_puzzle() -> void:
	puzzleImage = make_puzzle_image(puzzleImage)
	var piece_size = float(puzzleImage.get_width()) / 3.0
	var buttons = grid.get_children()
	var pieces = []
	
	# Create all nine pieces first
	for row in range(3):
		for col in range(3):
			var piece = AtlasTexture.new()
			piece.atlas = puzzleImage
			piece.region = Rect2(
				col * piece_size,
				row * piece_size,
				piece_size,
				piece_size
			)
			
			pieces.append(piece)
			
	
	# Create a bordered button for each piece
	for i in range(buttons.size()):
		buttons[i].set_meta("image_id", (i + 1))
		var button = buttons[i] as TextureButton
		button.texture_normal = pieces[i]
		button.set_meta("correct_position", pieces[i])
	
	buttons.shuffle()

	for button in buttons:
		$Puzzleboard/GridContainer.remove_child(button)
		$Puzzleboard/GridContainer.add_child(button)


func make_puzzle_image(source: Texture2D) -> Texture2D:
	var ingredient = source.get_image()
	ingredient.convert(Image.FORMAT_RGBA8)

	var image_size = max(
		ingredient.get_width(),
		ingredient.get_height()
	)

	var background = Image.create(
		image_size,
		image_size,
		false,
		Image.FORMAT_RGBA8
	)

	background.fill(Color.WHITE)

	var offset = Vector2i(
		(image_size - ingredient.get_width()) / 2,
		(image_size - ingredient.get_height()) / 2
	)

	background.blend_rect(
		ingredient,
		Rect2i(Vector2i.ZERO, ingredient.get_size()),
		offset
	)

	return ImageTexture.create_from_image(background)


func buttonsPressed(button: TextureButton):
	if imageToSwap == null:
		button.modulate = Color(0.621, 0.621, 0.621, 1.0)
		imageToSwap = button
	elif button == imageToSwap:
		imageToSwap.modulate = Color(1, 1, 1)
		imageToSwap = null
	else:
		swapButtons(imageToSwap, button)
		imageToSwap.modulate = Color(1, 1, 1)
		imageToSwap = null
		if checkCorrect() == true:
			label.text = "Won!"


func swapButtons(image1, image2):
	var index1 = image1.get_index()
	var index2 = image2.get_index()

	grid.move_child(image1, index2)
	grid.move_child(image2, index1)
	return

func checkCorrect() -> bool:
	var buttons = grid.get_children()
	for i in range(buttons.size()):
		if (i + 1) != buttons[i].get_meta("image_id"):
			return false
	return true

func _on_piece_1_pressed() -> void:
	buttonsPressed($Puzzleboard/GridContainer/Piece1)

func _on_piece_2_pressed() -> void:
	buttonsPressed($Puzzleboard/GridContainer/Piece2)

func _on_piece_3_pressed() -> void:
	buttonsPressed($Puzzleboard/GridContainer/Piece3)

func _on_piece_4_pressed() -> void:
	buttonsPressed($Puzzleboard/GridContainer/Piece4)

func _on_piece_5_pressed() -> void:
	buttonsPressed($Puzzleboard/GridContainer/Piece5)

func _on_piece_6_pressed() -> void:
	buttonsPressed($Puzzleboard/GridContainer/Piece6)

func _on_piece_7_pressed() -> void:
	buttonsPressed($Puzzleboard/GridContainer/Piece7)

func _on_piece_8_pressed() -> void:
	buttonsPressed($Puzzleboard/GridContainer/Piece8)

func _on_piece_9_pressed() -> void:
	buttonsPressed($Puzzleboard/GridContainer/Piece9)
