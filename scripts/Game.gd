extends Node

###############################
#HARD CODED OPTIONS FOR DEVELOPMENT PURPOSES
var dimx = 10
var dimy = 10
var game_mode = "PVE"
var player_turn=true
var number_of_opponents : int = 1

################################
#Mandatory script options
var target_maps : Array[GridMap]=[]
################################

#logging tool
var logg = logger_tool.new()

################################

@onready var shooting_map : GridMap = $World/Player_Map
@onready var camera_controller = $Controllers/CameraController
@onready var interaction_controller = $Controllers/InteractionController
@onready var game_controller = $Controllers/GameController
@onready var targets = $World/Targets


###################################
#HERE THE FUNCTIONAL CODE STARTS 
###################################




#Call functions from map_generation helper class called "map_generator"
var generator = map_generator.new()

#Artificial opponent variables and class initiaiton
var enemy = opponent.new()


func _ready() -> void:
	
	##########################################
	logg.assign_log_level(30)  # for debuging
	logg.log_source = "GAM_MAIN"
	##########################################
	
	
	generator.setup(targets,dimx,dimy)
	generator.create_target_boards(number_of_opponents,target_maps)
	generator.generate_map_3d(shooting_map,dimx,dimy)
	camera_controller.position_camera(shooting_map)
	interaction_controller.setup(camera_controller,target_maps)
	game_controller.setup(game_mode,enemy,target_maps)	
	
	


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interaction_controller.handle_click_interaction(event.position)
			#Returns the cell that a ray passing through mouse and camera collided with. It basically says where player intended to click.


func _input(event):
	if event.is_action_pressed("camera_pan"):
		#print(camera_shoot.position)
		camera_controller.switch_pan()
		
	
	if event.is_action_pressed("switch_map_left"):
		camera_controller.move_maps()
		
