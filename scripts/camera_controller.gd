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
var generator
var map_focus_selection : int = 0
var number_of_players

func setup(s_generator, s_number_of_players):
	generator = s_generator
	number_of_players = s_number_of_players
	return

var log1 = logger_tool.new()

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
	log1.log_source="CAM_CONT"
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
	
	log1.log30(calculated_position, "Calculated position for camera")
	
	return calculated_position

#move maps around when there is more than one
#positions available for boards are in a variable "arrangements"
#which position in the array a board should take is dependant on
#number of players and which map is currently viewed
#it is independant on camera movement up and down
#and it shift gridmaps around instead
func move_maps(maps, direction, duration : float = 0.3):
	
	#This value is just a number of players. There might be some issues in 
	#the future so it is a separate variable in this function just in case
	var map_no=number_of_players
	# this is a variable containing positions created automatically
	# during map creation in map generator
	var positions = generator.board_arrangements
	
	# this will hold a value for this position
	var new_position
	
	# this is the highest number of map the player can see
	var upper_bound :int = ((positions.size()+1)/2)-1
	
	# index of where currently moved board would be in the positions array
	# it is not there, board current position is assigned using different array
	# positions in those two arrays has to be matched
	# initial array does not contain additional positions that reflect moving
	# a board into positions lower that 0 in the original array
	# that is why the original array had to be extended
	var board_current_position_in_array : int
	
	# this is the index in the directions array where board will be moved
	var board_new_position_in_array : int
	
	#we don't move arrays if the player looks down
	if camera_at_a == true:
		return
	
	
	if tween_map:
		tween_map.kill()
	
	# if we look at the leftmost board we don't shift the boards to the right anymore
	# as there is nothing on the left anymore
	if direction == "right":
		if map_focus_selection==0:
			return
		else:
			# this modifies in which direction we will change array indexes
			direction = 1
		
	else:
		# if we look at the rightmost board we don't shift the boards left anymore
		# as there is nothing at the right
		# this is why upper bound was defined
		if map_focus_selection==upper_bound:
			print("upper_bound reached", upper_bound)
			return
		else:
			# this modifies in which direction we will change array indexes
			direction = -1
		
	tween_map = create_tween()
	tween_map.set_parallel(true)
	tween_map.set_trans(Tween.TRANS_SINE)	
	tween_map.set_ease(Tween.EASE_OUT)
	
	for i in range(map_no):
		#NOTICE
		# which index in the expanded array the current map position should be
		# it depends of number of players called map_no meaning number of oponent maps
		# there is two times as many board positions as opponent players minus one as the middle one overlaps
		# index i switches which map is currently moved
		# map focus tells which map player currently looks at
		# for 1 opponent this will always be 0
		# for 2 opponents when looking at the map with index 1 we will get 0 for map 0 and 1 for map no. 1
		# indexes start at zero indexes start at zero indexes start at zero
		board_current_position_in_array = map_no-1+i-map_focus_selection
		#print("map ", i, " is now in position ", board_current_position_in_array)
		
		#NOTICE
		#new position in the direction array will be modified by direction
		# it will go one more or one less depending on whether left or right was selected
		board_new_position_in_array= board_current_position_in_array+direction
		#print("map ", i, " becomes ", board_new_position_in_array)
		
		#NOTICE
		#value of vector containing new position taken from positions array
		new_position=positions[board_new_position_in_array]
		#print(new_position)
		tween_map.tween_property(
			maps[i],
			"position",
			new_position,
			duration
		)
		#NOTICE
		#switch value that tells which map the player is looking at
	map_focus_selection=map_focus_selection-direction
