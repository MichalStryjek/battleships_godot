extends Node3D

#@onready var camera_controller = $"../CameraController"

var camera_controller
var highlighter_controller
var target_maps
var old_object
var old_cell
#var target_maps : Array[GridMap]
var camera : Camera3D
func setup(s_camera_controller,s_target_maps,s_highlighter_controller):
	camera_controller=s_camera_controller
	camera = camera_controller.get_camera()
	target_maps=s_target_maps
	highlighter_controller = s_highlighter_controller
	return


var logg = logger_tool.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	#############################
	
	logg.assign_log_level(20)
	
	#############################
	
	pass # Replace with function body.


func raycast_from_camera(mouse_pos: Vector2, collision_mask=4294967295):
	##########################
	#logg.log_source="RAY_CAST"
	##########################
	###For debugging the returned results are broader
	###print ("mouse: ",mouse_pos)
	var from = camera.project_ray_origin(mouse_pos)
	###Indicate beginning point of the ray
	###print ("ray origin: ", from)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000.0
	###Indicate target of the rey. It is somewhere far away. Clicked object should be somewhere before the end point.
	var query = PhysicsRayQueryParameters3D.create(from, to)
	###This prepares parameters for the shooting
	
	#if value provided is different than default then use it
	#It is an attempt at optimalisation
	if collision_mask==4294967295:
		pass
	else:
		query.collision_mask=collision_mask

	
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	#print("LOG: raycast result ", result)
	
	return result

# Called every frame. 'delta' is the elapsed time since the previous frame.
func handle_click_interaction(click_position):	
	
	var result = raycast_from_camera(click_position,1)
	
	logg.log_source="INT_HAND"
	
	if result.is_empty():
		return
	
	var object = result.collider
	
	if object.has_method("interact"):
		object.intereact()
	
	elif object is GridMap:
		logg.log30("Detected click on GRIDMAP")		
		logg.log40(str("GridMap name is ", object.name))
		interact_with_grid(result)
	return


func get_grid_coordinates(raycast_colision):
	var board_collided : GridMap = raycast_colision.collider
	var grid_local_position = board_collided.local_to_map(board_collided.to_local(raycast_colision.position)) 	
	
	return grid_local_position

func interact_with_grid(grid_result):
	
	logg.log_source="INT_GRID"
	
	var grid=grid_result.collider
	var grid_coordinates = get_grid_coordinates(grid_result)	
	logg.log40(grid.name, "Confirming name")
	logg.log20(get_grid_coordinates(grid_result), "Detected coordinates")	
	var coords=get_grid_coordinates(grid_result)
	var a = randf()
	if a > 0.5:
		a=1
	else:
		a=2
	grid.set_cell_item(coords,a,0)
	return 

func handle_hover(cursor_position):
	var result = raycast_from_camera(cursor_position,1)
	var object
	var cell
	if result.is_empty():
		highlighter_controller.hide_hover()
		return
	object = result.collider
	
	if object is GridMap:
		cell = get_grid_coordinates(result)
		if object == old_object and cell == old_cell:
			return
		else:
		#logg.log20("Hover over gridmap")
			old_object = object
			old_cell=cell
			highlighter_controller.highlight_gridmap(object, cell)
	return
