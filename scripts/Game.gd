extends Node

##########################################################################
#VARIABLES SETUP
##########################################################################

#Declare Node variables

@onready var shooting_map : GridMap = $World/Player_Map
@onready var camera_controller = $Controllers/CameraController
@onready var interaction_controller = $Controllers/InteractionController
@onready var game_controller = $Controllers/GameController
@onready var targets = $World/Targets
@onready var setup_controller = $Controllers/Setup_Controller
@onready var input_manager = $InputManager
@onready var highlighter_controller = $Controllers/PlayerFeedbackController/HighlighterControl
@onready var highlight_tile = $World/Highlights/GridCellHighlight
##########################################################################

#Declare class variables

#Call functions from map_generation helper class called "map_generator".
#It could be a node as well
var generator = map_generator.new()
var enemy = opponent.new() #Artificial opponent variables and class initiaiton
################################

#Game options

var target_maps : Array[GridMap]=[]
var game_parameters :Dictionary = {

"number_of_opponents" : 1,
"dimx" : 1,
"dimy" : 1,
"game_mode" : "Unassigned"

}
################################

#logging tool
var logg = logger_tool.new()
################################


###################################
#HERE THE FUNCTIONAL CODE STARTS 
###################################


func _ready() -> void:
	
	###########################################
	logg.assign_log_level(30)  # for debuging
	logg.log_source = "GAM_MAIN"
	##########################################
	
	setup_controller.assign_settings_to_the_game(game_parameters)
	setup_initial_systems()
	setup_dependant_systems()
	

func setup_initial_systems() -> void:
	generator.setup(targets,game_parameters["dimx"],game_parameters["dimy"])
	generator.create_target_boards(game_parameters["number_of_opponents"],target_maps) #Targetmaps gets here its value
	generator.generate_map_3d(shooting_map,game_parameters["dimx"],game_parameters["dimy"])
	camera_controller.setup(generator,game_parameters["number_of_opponents"])
	camera_controller.position_camera(shooting_map)
	highlighter_controller.setup(highlight_tile)
	
func setup_dependant_systems() -> void:
	interaction_controller.setup(camera_controller,target_maps, highlighter_controller)
	game_controller.setup(game_parameters["game_mode"],enemy,target_maps)	
	input_manager.setup(camera_controller,interaction_controller,target_maps)
	
