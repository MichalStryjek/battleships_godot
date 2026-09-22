extends Node

##########################################################################
#VARIABLES SETUP
##########################################################################

#Declare Node variables

@onready var player_map : GridMap = $World/Player_Map
@onready var camera_controller = $Controllers/CameraController
@onready var interaction_controller = $Controllers/InteractionController
@onready var game_controller = $Controllers/GameController
@onready var targets = $World/Targets
@onready var setup_controller = $Controllers/SetupController
@onready var input_manager = $InputManager
@onready var highlighter_controller = $Controllers/PlayerFeedbackController/HighlighterControl
@onready var display_manager = $DisplayManager
@onready var board_controller = $Controllers/BoardController
@onready var player_controller = $Controllers/PlayerController

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
	setup_game_window()
	setup_initial_systems()
	setup_dependant_systems()
	
	initiate_players()
	initiate_game_boards()
	initiate_artificial_opponents()
	
	begin_game()

func setup_initial_systems() -> void:
	generator.setup(targets,game_parameters["dimx"],game_parameters["dimy"])
	generator.create_target_maps(game_parameters["number_of_opponents"],target_maps) #Targetmaps gets here its value
	generator.generate_map_3d(player_map,game_parameters["dimx"],game_parameters["dimy"])
	camera_controller.setup(generator,game_parameters["number_of_opponents"])
	camera_controller.position_camera(player_map)
	
func setup_dependant_systems() -> void:
	interaction_controller.setup(camera_controller,target_maps, highlighter_controller)
	input_manager.setup(camera_controller,interaction_controller,target_maps)
	game_controller.setup(game_parameters["game_mode"],enemy,target_maps)	
	board_controller.setup(player_controller)
	
	
func setup_game_window():
	display_manager.set_window_size()
	pass

func initiate_players():
	player_controller.initiate_players(game_parameters["number_of_opponents"])
	pass

func initiate_game_boards():
	board_controller.setup_boards()

func initiate_artificial_opponents():
	
	pass

func begin_game():
	game_controller.start()
