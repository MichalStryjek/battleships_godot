extends Node3D

@onready var highlight_tile: MeshInstance3D = $"../../../World/Highlights/GridCellHighlight"

func get_highlight_tile():
	return highlight_tile

func setup(s_highlight_tile):
	highlight_tile=s_highlight_tile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func hide_hover():
	highlight_tile.hide()
	return

func highlight_gridmap(board_to_highlight : GridMap,cell_to_highlight):
	var vertical_offset = 0
	cell_to_highlight.y += vertical_offset
	var local_pos = board_to_highlight.map_to_local(cell_to_highlight)
	var world_pos = board_to_highlight.to_global(local_pos)
	highlight_tile.global_position = world_pos
	if board_to_highlight.is_in_group("opponent_maps"):
		highlight_tile.global_rotation_degrees = Vector3i(0,0,90)
	else:
		highlight_tile.global_rotation_degrees = Vector3i(0,0,0)
	highlight_tile.show()
	return
