class_name map_generator
extends Node3D

func generate_map_3d(shooting_map: GridMap,x,y):
	
	for i in x:
		for j in y:
			shooting_map.set_cell_item(Vector3i(i,0,j),0,0)
	
	pass
