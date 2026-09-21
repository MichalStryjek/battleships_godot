class_name map_generator
extends Node3D

const TARGET_BOARD_SCENE = preload("res://scenes/target_board.tscn")

var targets

var dimx
var dimy

var board_positions : Array[Vector3] =[]
var board_arrangements : Array[Vector3] = [] #This contains also slots for arrays to move into whe changing view

func setup(setup_targets, s_dimx,s_dimy):
	targets=setup_targets
	dimx = s_dimx
	dimy = s_dimy
	return


func generate_map_3d(grid: GridMap,x,y):
	
	for i in x:
		for j in y:
			grid.set_cell_item(Vector3i(i,0,j),0,0)
	
	pass



#Dynamically create target boards as well as their remote nodes during game run
#So it creates targets but it also returns a value of target boards array 
#for main script to hold
func create_target_boards(opponents_no,target_maps):
	#Array that decides positions of the boards
	
	for i in range(opponents_no):
		#Read and initiate scene containing opponent board
		var board = TARGET_BOARD_SCENE.instantiate()
		
		#Generate position of the board
		var pos=Vector3(20,10,i*40)
		board_positions.append(pos)
		
		#Add godot nodes
		board.name = "TargetBoard_%d" % (i+1)
		targets.add_child(board)
		
		#Assign position and rotation to the board
		board.position=board_positions[i]
		board.rotation_degrees=Vector3i(0,0,90)
		
		generate_map_3d(board,dimx,dimy)
		#Append to the array of target maps for future reference
		
		target_maps.append(board)
		board.add_to_group("opponent_maps")
	#It has to work on duplicate because in Godot the array changes even
	#Though it is a parameter of a function
	board_arrangements=board_positions.duplicate()
	mirror_board_positions(board_arrangements)
	return
#This function creates an array that contains board positions 
#as well as their reflections in horizontal axis
func mirror_board_positions(pos: Array[Vector3]):
	#print("START ",pos)
	var pos_backup = pos.duplicate()
	pos.reverse()
	#print("REVERSED ",pos)
	pos.resize(pos.size()-1)
	#print("RESIZED ",pos)
	for i in pos.size():
		#print(pos[i])
		pos[i] = pos[i]*Vector3(1,1,-1)
	#print("MULTIPLIED ",pos)
	pos.append_array(pos_backup)
	#print("APPENDED ",pos)
	return pos
