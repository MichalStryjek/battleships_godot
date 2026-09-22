extends Node

var game_mode
var enemy
var secret_board
var target_maps

func setup(setup_game_mode, setup_target_maps):
	game_mode=setup_game_mode
	target_maps=setup_target_maps
	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
		if game_mode == "PVE":
			secret_board=enemy.generate_game_array()
	
	
		pass # Replace with function body.

func start():
	pass


func interact_with_cell(cell: Vector3i):
	#print(cell)
	var item_id = target_maps[0].get_cell_item(cell)
	#print(item_id)
	if item_id == GridMap.INVALID_CELL_ITEM:
		return
	compare_cell(cell,enemy.secred_board)

func compare_cell(cell,grid):
	var i = cell[0]
	var j = cell[2]
	var result=grid[i][j]
	return result
