extends GridMap

func find_center(PM):
	var gridmap: GridMap = PM
	print(gridmap.get_used_cells())
	print(gridmap.get_used_cells().min())
	print(gridmap.get_used_cells().max())
