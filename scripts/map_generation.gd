class_name map_generator
extends Node3D

func generate_map_3d(shooting_map: GridMap,x,y):
	
	for i in x:
		for j in y:
			shooting_map.set_cell_item(Vector3i(i,0,j),0,0)
	
	pass


func position_camera(_cam: Camera3D,map : GridMap, shooting_map : bool):
# shooting_map if true means that the map is used for shooting or is it the one containing player ships	
	var map_min : Vector3i
	var map_max : Vector3i
	var map_min_x : int
	var map_min_y : int
	var map_max_x : int
	var map_max_y : int
	var camera_pos_x : float
	var camera_pos_y : float
	var camera_pos_z : float
	
	map_min = map.get_used_cells().min()
	map_max = map.get_used_cells().max()
	
	map_min_x = map_min[2]
	map_max_x = map_max[2]
	map_min_y = map_min[0]
	map_max_y = map_max[0]
	
	camera_pos_x = map_max_x
	camera_pos_y = map_max_y
	camera_pos_z = (map_max_x+map_max_y)*0.60
	
	return Vector3(camera_pos_y,camera_pos_z,camera_pos_x)
