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
#var enemy = opponent.new() #Artificial opponent variables and class initiaiton
################################

#Game options

var target_maps : Array[GridMap]=[]
var match_parameters :Dictionary = {}
var local_id
var board_map : Dictionary = {} #Pairs of logical boards to local graphical maps
var opponents_number
var players_connected
var computer_opponents : Dictionary = {}
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
	
	#Display settings for the application
	setup_game_window()
	#####################################################
	#Generate setup parameters for the match
	setup_controller.provide_match_settings()
	setup_controller.assign_settings_to_the_game(match_parameters)
	opponents_number = match_parameters["number_of_opponents"]
	#####################################################
	#NOTICE Those are independant on which player is the client.
	#It is absolute game state
	
	#Create players
	initiate_players()
	#Create logical boards
	
	#ATTENTION ASSIGN ID TO MULTIPLAYER PLAYERS HERE #
	#WARNING PLACEHOLDER FUNCTION WARNING
	local_id=0
	players_connected=0
	#Players are assigned to boards here as well. Board ID = Player ID
	#for simplicity
	initiate_game_boards()
	
	setup_generator_systems()
	#Generate target maps nodes and array
	initiate_target_maps()
	######################################################
	#Setup local instance of the game
	
	#Setup nodes that do not require other nodes
	

	create_board_to_map_pairs()
	
	
	#Execute functions on the nodes. They assign values to dependant nodes
	#At this point it should be known which player has which board
	#And which map to display as player map
	generate_world()
	
	#Setup nodes that require other nodes or variables to already exist
	setup_dependant_systems()
	
	initiate_artificial_opponents()
	
	begin_game()
	
	
	
	
	
	
	
	
	
func setup_generator_systems() -> void:
	generator.setup(setup_controller)

func setup_dependant_systems() -> void:
	camera_controller.setup(generator,opponents_number)
	interaction_controller.setup(camera_controller, highlighter_controller)
	input_manager.setup(camera_controller,interaction_controller,target_maps)
	game_controller.setup()	
	
func setup_game_window():
	display_manager.set_window_size()

func initiate_players():
	player_controller.initiate_players(opponents_number)

func initiate_game_boards():
	board_controller.setup(player_controller)
	board_controller.setup_boards(match_parameters["map_sizes"])



func initiate_artificial_opponents():
	var artificial_opponents_to_create=0
	var players = player_controller.players
	var unassigned_player_ids : Array = []
	for player_id in players:
		var player_obj = player_controller.get_player(player_id)
		if player_obj.is_human == player_obj.IsHuman.NO:
			artificial_opponents_to_create += 1
			unassigned_player_ids.append(player_id)
	for i in range(artificial_opponents_to_create):
		var opp = opponent.new()
		opp.opponent_id=unassigned_player_ids[i]
	pass

func begin_game():
	game_controller.start()

func generate_world():
	generator.create_maps(player_map,local_id)
	camera_controller.position_camera(player_map)

func create_board_to_map_pairs():
	player_board_to_map()
	opponent_board_to_map()
func player_board_to_map():	
	board_map[player_map]=board_controller.get_board_by_owner(local_id)

func opponent_board_to_map():
	var players = player_controller.players
	var array_index = 0 #moving by one in every loop
	var dictionary_index = 0 #move by one but skip the local player map
	#Go through every player id
	#Putting -1 because map indexes start from 0
	for player_id in players:
		#logg.log40(array_index,"array index")
		#logg.log40(dictionary_index,"dic index")
		if player_id!=local_id:
			#logg.log40("NO for player ID assigning values to dictionary %d and array %d" %[dictionary_index,array_index])
			board_map[target_maps[array_index]]=board_controller.get_board_by_owner(dictionary_index)
			
		else:
			#If the player id is local player skip this board, but dont skip target map
			dictionary_index +=1
			#logg.log40("YES for player ID not assigning any values")
			#board_map[target_maps[array_index]]=board_controller.get_board_by_owner(dictionary_index)
			continue
		array_index += 1
		dictionary_index += 1

func initiate_target_maps():
	generator.generate_target_maps(targets,target_maps)
