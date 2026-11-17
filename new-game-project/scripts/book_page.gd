extends PanelContainer

@export_range(0, 1) var page_side := 0

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()

func _draw() -> void:
	var page_size := size
	if page_size.x <= 0.0 or page_size.y <= 0.0:
		return

	# Build the page from hard-edged rectangles so it keeps the game's pixel look.
	draw_rect(Rect2(Vector2.ZERO, page_size), Color("574438"))
	draw_rect(Rect2(2, 2, page_size.x - 4, page_size.y - 4), Color("a58a5c"))
	draw_rect(Rect2(4, 4, page_size.x - 8, page_size.y - 8), Color("d8c79d"))
	draw_rect(Rect2(6, 6, page_size.x - 12, 2), Color("c2ad7f"))
	draw_rect(Rect2(6, page_size.y - 8, page_size.x - 12, 2), Color("b9a173"))

	var stain_colour := Color("96794f", 0.16)
	var dark_stain := Color("826747", 0.13)
	var stains_left := [
		Vector2(0.83, 0.17), Vector2(0.17, 0.49), Vector2(0.78, 0.81),
		Vector2(0.42, 0.92), Vector2(0.57, 0.29)
	]
	var stains_right := [
		Vector2(0.18, 0.19), Vector2(0.84, 0.45), Vector2(0.24, 0.82),
		Vector2(0.68, 0.92), Vector2(0.47, 0.36)
	]
	var stains: Array = stains_left if page_side == 0 else stains_right

	for i in range(stains.size()):
		var point: Vector2 = stains[i] * page_size
		var block := 3.0 if i % 2 == 0 else 2.0
		draw_rect(Rect2(point + Vector2(-block, -block), Vector2(block * 2, block)), stain_colour)
		draw_rect(Rect2(point + Vector2(-block * 2, 0), Vector2(block * 4, block * 2)), dark_stain)
		draw_rect(Rect2(point + Vector2(-block, block * 2), Vector2(block * 3, block)), stain_colour)

	# Tiny ink and age flecks are deliberately square, not blurred.
	var flecks := [
		Vector2(0.12, 0.30), Vector2(0.31, 0.13), Vector2(0.67, 0.22),
		Vector2(0.90, 0.66), Vector2(0.14, 0.73), Vector2(0.59, 0.86),
		Vector2(0.37, 0.62), Vector2(0.79, 0.55), Vector2(0.25, 0.91)
	]
	for i in range(flecks.size()):
		var point: Vector2 = flecks[i] * page_size
		var fleck_size := 2.0 if i % 3 == 0 else 1.0
		draw_rect(Rect2(point, Vector2(fleck_size, fleck_size)), Color("755d3f", 0.2))
