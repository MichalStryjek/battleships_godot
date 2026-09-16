extends Node3D

@onready var camera : Camera3D = $Camera3D
var tween: Tween

func get_camera() -> Camera3D:
	return camera

func pan_camera_to(target_rotation: Vector3, target_position: Vector3, duration: float = 0.3):
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE)	
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(
		camera,
		"rotation_degrees",
		target_rotation,
		duration
	)
	
	tween.tween_property(
		camera,
		"position",
		target_position,
		duration
	)
#immediately move camera here
func camera_position(position_start: Vector3):
	camera.position=position_start

func camera_rotation(position_start: Vector3):
	camera.rotation_degrees=position_start

#automatically find starting position of camera depending on map size
func position_camera(map : GridMap, _cam : Camera3D=camera, shooting_map : int=0):
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
	
	return Vector3(camera_pos_y,camera_pos_z,camera_pos_x)
