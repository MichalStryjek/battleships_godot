extends Node

var enemy
var secret_board

enum GamePhase


{
	PLACEMENT,
	GAME,
	FINISH
	
	
}

func setup():
	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		
		pass # Replace with function body.

func start():
	pass

func setup_ships():
	pass
func indicate_ready():
	pass

func click_on_grid(grid, cell: Vector3i):
	#print(cell)
	#var target_maps : Array = []
	#var item_id = target_maps[0].get_cell_item(cell)
	#print(item_id)
	#if item_id == GridMap.INVALID_CELL_ITEM:
	#	return
	#print("AAAAA",cell)
	#compare_cell(cell,enemy.secred_board)
	pass 
	
func compare_cell(cell,grid):
	var i = cell[0]
	var j = cell[2]
	var result=grid[i][j]
	return result
