class_name interaction
extends Node3D


func get_gridmap_cell(shooting_map: GridMap, camera_shoot:Camera3D,mouse_pos: Vector2) -> Vector3i:
	#For debugging the returned results are broader
	#print ("mouse: ",mouse_pos)
	var from = camera_shoot.project_ray_origin(mouse_pos)
	#Indicate beginning point of the ray
	#print ("ray origin: ", from)
	var to = from + camera_shoot.project_ray_normal(mouse_pos) * 1000.0
	#Indicate target of the rey. It is somewhere far away. Clicked object should be somewhere before the end point.
	var query = PhysicsRayQueryParameters3D.create(from, to)
	#This prepares parameters for the shooting
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	#Shoot and save result. If any collision shape was hit a result is provided.
	if result.is_empty():
		return Vector3i(-1, -1, -1)
	#Value returned if no collision happens on rays path
	var hit_position: Vector3 = result.position


	return shooting_map.local_to_map(
		shooting_map.to_local(hit_position)
	)
	# Convert world position to GridMap coordinates
