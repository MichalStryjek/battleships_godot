extends Node3D

var highlight_tile

func setup(s_highlight_tile):
	highlight_tile=s_highlight_tile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func highlight_gridmap(board_to_highlight : GridMap,cell_to_highlight):
	var vertical_offset = 0.5
	cell_to_highlight.y += vertical_offset
	var local_pos = board_to_highlight.map_to_local(cell_to_highlight)
	var world_pos = board_to_highlight.to_global(local_pos)
	highlight_tile.global_position = world_pos
	highlight_tile.show()
	return
