extends Node3D

@onready var camera : Camera3D = $Camera3D
var tween_up: Tween
var tween_map: Tween

#Camera position variables ALL OF THOSE WILL BE MOVED TO SETUP FUNCTION
var camera_rotation_a : Vector3 = Vector3(-80,-90,0)
var camera_position_a : Vector3
var camera_position_b : Vector3
var position_shift: Vector3 = Vector3(1,8.5,0) 
var camera_rotation_b : Vector3 = camera_rotation_a+ Vector3(80,0,0)
var camera_at_a : bool = true

func setup():
	return

var log = logger_tool.new()

func get_camera() -> Camera3D:
	return camera

func switch_pan():
	if camera_at_a:
		pan_camera_to(camera_rotation_b,camera_position_b)
	else:
		pan_camera_to(camera_rotation_a,camera_position_a)
	camera_at_a=!camera_at_a


func pan_camera_to(target_rotation: Vector3, target_position: Vector3, duration: float = 0.3):
	
	if tween_up:
		tween_up.kill()
	
	tween_up = create_tween()
	tween_up.set_parallel(true)
	tween_up.set_trans(Tween.TRANS_SINE)	
	tween_up.set_ease(Tween.EASE_OUT)
	tween_up.tween_property(
		camera,
		"rotation_degrees",
		target_rotation,
		duration
	)
	
	tween_up.tween_property(
		camera,
		"position",
		target_position,
		duration
	)


func position_camera(map : GridMap):
	
	camera_position_a=find_camera_position(map)
	camera_position_b=camera_position_a+position_shift
	
	camera.position=camera_position_a
	camera.rotation_degrees=camera_rotation_a
	
	return

#automatically find starting position of camera depending on map size
func find_camera_position(map : GridMap, _cam : Camera3D=camera):
	
	var calculated_position : Vector3
	
	#######
	log.log_source="CAM_CONT"
	######
# target_map is to be used for camera position in case of multiple maps
	var map_min : Vector3i
	var map_max : Vector3i
	var _map_min_x : int
	var _map_min_y : int
	var map_max_x : int
	var map_max_y : int
	var camera_pos_x : float
	var camera_pos_y : float
	var camera_pos_z : float
	
	map_min = map.get_used_cells().min()
	map_max = map.get_used_cells().max()
	
	#it is written like that so it is easier to understand after taking a break from code
	_map_min_x = map_min[2]
	map_max_x = map_max[2]
	_map_min_y = map_min[0]
	map_max_y = map_max[0]
	
	camera_pos_x = map_max_x
	camera_pos_y = map_max_y-1
	camera_pos_z = (map_max_x+map_max_y)*0.60
	
	calculated_position=Vector3(camera_pos_y,camera_pos_z,camera_pos_x)
	
	log.log30(calculated_position, "Calculated position for camera")
	
	return calculated_position

#move maps around when there is more than one
func move_maps(map,old_position, new_position, direction, duration):
	
	if camera_at_a == true:
		pass
	
	
	if tween_map:
		tween_map.kill()
	if direction == "left":
		direction = 1
	else:
		direction = -1
	tween_map = create_tween()
	#tween.set_parallel(true)
	tween_map.set_trans(Tween.TRANS_SINE)	
	tween_map.set_ease(Tween.EASE_OUT)
	
	tween_map.tween_property(
		map,
		"position",
		old_position+(new_position*direction),
		duration
	)
	
