extends Node3D


var dimx = 10
var dimy = 10
var game_mode = "PVE"

@onready var shooting_map : GridMap = $Player_Map
@onready var target_map : GridMap = $Target_Map
@onready var camera_controller = $CameraController
@onready var camera_shoot = $CameraController/Camera3D

#Call functions from map_generation helper class called "map_generator"
var generator = map_generator.new()


#Artificial opponent variables and class initiaiton
var enemy = opponent.new()
var secred_board

#Camera position variables
var camera_rotation_a : Vector3 = Vector3(-80,-90,0)
var camera_position_a : Vector3
var camera_position_b : Vector3
var position_shift: Vector3 = Vector3(1,8.5,0) 
var camera_rotation_b : Vector3 = camera_rotation_a+ Vector3(80,0,0)
var camera_at_a : bool = true



func _ready() -> void:
	generator.generate_map_3d(shooting_map,dimx,dimy)
	generator.generate_map_3d(target_map,dimx,dimy)
	
	camera_position_a=camera_controller.position_camera(shooting_map)
	camera_position_b=camera_position_a+position_shift
	
	camera_controller.camera_position(camera_position_a)
	camera_controller.camera_rotation(camera_rotation_a)

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

func _input(event):
	if event.is_action_pressed("camera_pan"):
		#print(camera_shoot.position)
		if camera_at_a:
			camera_controller.pan_camera_to(camera_rotation_b,camera_position_b)
		else:
			camera_controller.pan_camera_to(camera_rotation_a,camera_position_a)
		camera_at_a=!camera_at_a
		


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
	
	if item_id == GridMap.INVALID_CELL_ITEM:
		print ("WHOPSIE NIE DZIAŁA PANOCZKU")
		return
	compare_cell(cell,secred_board)
	print("Interacted with cell: ", cell)

func compare_cell(cell,grid):
	var i = cell[0]
	var j = cell[2]
	var result=grid[i][j]
	shooting_map.set_cell_item(cell,result,0)
