extends Node


var dimx = 10
var dimy = 10
var game_mode = "PVE"

@onready var shooting_map : GridMap = $World/Player_Map
@onready var target_map : GridMap = $World/Target_Map
@onready var camera_controller = $Controllers/CameraController
@onready var camera_shoot = $Controllers/CameraController/Camera3D
@onready var interaction_controller = $Controllers/InteractionController


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
			interaction_controller.handle_click_interaction(event.position)
			#Returns the cell that a ray passing through mouse and camera collided with. It basically says where player intended to click.


func _input(event):
	if event.is_action_pressed("camera_pan"):
		#print(camera_shoot.position)
		if camera_at_a:
			camera_controller.pan_camera_to(camera_rotation_b,camera_position_b)
		else:
			camera_controller.pan_camera_to(camera_rotation_a,camera_position_a)
		camera_at_a=!camera_at_a
		


#
func interact_with_cell(cell: Vector3i):
	print(cell)
	var item_id = target_map.get_cell_item(cell)
	print(item_id)
	if item_id == GridMap.INVALID_CELL_ITEM:
		print ("ERROR: empty cell has been hit/collider from other object")
		return
	compare_cell(cell,secred_board)
	print("Interacted with cell: ", cell)

func compare_cell(cell,grid):
	var i = cell[0]
	var j = cell[2]
	var result=grid[i][j]
	shooting_map.set_cell_item(cell,result,0)
