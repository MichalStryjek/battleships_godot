extends Node3D


var dimx = 10
var dimy = 10
var game_mode = "PVE"

@onready var shooting_map : GridMap = $Player_Map
@onready var camera_shoot : Camera3D = $Player_Map/Camera3D

var generator = map_generator.new()
var enemy = opponent.new()
var secred_board

func _ready() -> void:
	generator.generate_map_3d(shooting_map,dimx,dimy)
	camera_shoot.position = generator.position_camera(camera_shoot, shooting_map,1)
	camera_shoot.rotation_degrees=Vector3(-80,-90,0)
	
	if game_mode == "PVE":
		secred_board=enemy.generate_game_array()
	

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var cell = get_gridmap_cell(event.position)
			#Returns the cell that a ray passing through mouse and camera collided with. It basically says where player intended to click.

			if cell != Vector3i(-1, -1, -1):
				interact_with_cell(cell)
				#Make an action on found cell
			else:
				print("nie działa")
				#For debuging

func get_gridmap_cell(mouse_pos: Vector2) -> Vector3i:
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

func interact_with_cell(cell: Vector3i):
	var item_id = shooting_map.get_cell_item(cell)
	compare_cell(cell,secred_board)
	if item_id == GridMap.INVALID_CELL_ITEM:
		print ("WHOPSIE NIE DZIAŁA PANOCZKU")
		return

	print("Interacted with cell: ", cell)

func compare_cell(cell,grid):
	var i = cell[0]
	var j = cell[2]
	var result=grid[i][j]
	shooting_map.set_cell_item(cell,result,0)

	
