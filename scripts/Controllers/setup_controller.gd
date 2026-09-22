extends Node

#Mandatory script options
var target_maps : Array[GridMap]=[]
var dimx : int = 10
var dimy : int = 10
var input_settings : Dictionary = {}

enum mapSizes{
	SMALL=8,
	MEDIUM=10,
	LARGE=15,
	XLARGE=20
}

########THIS WILL BE CONFIGURABLE##########
var number_of_maps_and_players = 4
##########################################


func provide_match_settings():
	var map_sizes : Dictionary = {}
	###SOMEDAY PLAYER WILL BE ABLE TO SELECT MAP SIZE ####
	for i in range(number_of_maps_and_players):
		var label = str("map_",i)
		map_sizes[label]=mapSizes.MEDIUM
	#############################################################
	input_settings["map_sizes"] = map_sizes
	input_settings["number_of_opponents"] = number_of_maps_and_players-1
	input_settings["game_mode"] = "PVE"


func assign_settings_to_the_game(parameters : Dictionary):
	parameters["number_of_opponents"] = input_settings["number_of_opponents"]
	parameters["map_sizes"]=input_settings["map_sizes"]
	parameters["game_mode"]=input_settings["game_mode"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
