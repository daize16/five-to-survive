extends Node2D

@export var maze_width: int = 10
@export var maze_height: int = 8
@onready var wall_layer: TileMapLayer = $WallLayer
@onready var floor_layer: TileMapLayer = $FloorLayer
@export var player: Node2D
@export var exit: Area2D


var maze: Array = []
var goal_cell: Vector2i = Vector2i(1, 1)
var dead_ends: Array[Vector2i] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generateMaze()
	var start_cell = Vector2i(1, 1)
	player.global_position = wall_layer.to_global(
		wall_layer.map_to_local(start_cell)
	)
	pickGoal()
	exit.global_position = wall_layer.to_global(
		wall_layer.map_to_local(goal_cell)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generateMaze():
	maze.clear()
	dead_ends.clear()
	var grid_width = (maze_width * 2) + 1
	var grid_height = (maze_height * 2) + 1

	for y in range(grid_height):
		var row = []
		for x in range(grid_width):
			row.append(true) #true = a wall
		maze.append(row)
	
	var start = Vector2i(0, 0)
	maze[1][1] = false
	
	var visited: Dictionary = {}
	visited[start] = true

	var stack: Array[Vector2i] = []
	stack.append(start)
	
	var directions = [
		Vector2i(0, -1),  # Up
		Vector2i(1, 0),   # Right
		Vector2i(0, 1),   # Down
		Vector2i(-1, 0)   # Left
	]
	
	while not stack.is_empty():
		var current = stack[-1]
		var neighbours: Array[Vector2i] = []
		for direction in directions:
			var next = current + direction
			if (next.x >= 0 and next.x < maze_width and next.y >= 0 and next.y < maze_height and not visited.has(next)):
				neighbours.append(next)
		if not neighbours.is_empty():
			var next = neighbours.pick_random()
			var direction_to_next = next - current
			var wall = current * 2 + Vector2i.ONE + direction_to_next
			maze[wall.y][wall.x] = false
			var next_cell = next * 2 + Vector2i.ONE
			maze[next_cell.y][next_cell.x] = false
			goal_cell = next_cell
			visited[next] = true
			stack.append(next)
		else:
			var open_neighbours = 0

			for direction in directions:
				var neighbour = current + direction
				if visited.has(neighbour):
					var between = current * 2 + Vector2i.ONE + direction
					if maze[between.y][between.x] == false:
						open_neighbours += 1

			if open_neighbours == 1 and current != start:
				var dead_end = current * 2 + Vector2i.ONE
				dead_ends.append(dead_end)
			stack.pop_back()
			
	drawTiles(maze)


func drawTiles(maze_arrangement):
	wall_layer.clear()
	floor_layer.clear()
	for y in range(maze_arrangement.size()):
		for x in range(maze_arrangement[y].size()):
			if maze_arrangement[y][x] == true:
				wall_layer.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
			else:
				floor_layer.set_cell(Vector2i(x, y), 1, Vector2i(0, 1))

func pickGoal():
	var furthestdeadend = Vector2i(1,1)
	for vector in dead_ends:
		var distance = Vector2i(1,1).distance_to(vector)
		if distance > Vector2i(1,1).distance_to(furthestdeadend):
			furthestdeadend = vector
	goal_cell = furthestdeadend
