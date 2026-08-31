extends Node3D
#
var dimx = 8
var dimy = 8

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var cell = get_gridmap_cell(event.position)

			if cell != Vector3i(-1, -1, -1):
				interact_with_cell(cell)
			else:
				print("nie działa")
				
				

func get_gridmap_cell(mouse_pos: Vector2) -> Vector3i:
	print ("mouse: ",mouse_pos)
	var from = $Player_Map/Camera3D.project_ray_origin(mouse_pos)
	$Player_Map/Camera3D.project_ray_origin(mouse_pos)
	print ("ray origin: ", from)
	var to = from + $Player_Map/Camera3D.project_ray_normal(mouse_pos) * 1000.0

	var query = PhysicsRayQueryParameters3D.create(from, to)
	print (get_viewport())
	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if result.is_empty():
		return Vector3i(-1, -1, -1)

	var hit_position: Vector3 = result.position

	# Convert world position to GridMap coordinates
	return $Player_Map.local_to_map(
		$Player_Map.to_local(hit_position)
	)
## Called when the node enters the scene tree for the first time.

func interact_with_cell(cell: Vector3i):
	var item_id = $Player_Map.get_cell_item(cell)

	if item_id == GridMap.INVALID_CELL_ITEM:
		print ("WHOPSIE NIE DZIAŁA PANOCZKU")
		return

	print("Interacted with cell: ", cell)
	print("Tile/item ID: ", item_id)

func _ready() -> void:
	generate_map_3d(dimx,dimy,0)
	pass
#
func generate_map_3d(x,y,z):
	
	for i in x:
		for j in y:
			$Player_Map.set_cell_item(Vector3i(i,0,j),0,0)
	$Player_Map/Camera3D.position = Vector3(8,10,7)
	pass
