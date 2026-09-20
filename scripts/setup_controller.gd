extends Node

#Mandatory script options
var target_maps : Array[GridMap]=[]
var number_of_opponents : int =4
var dimx : int = 10
var dimy : int = 10
var game_mode : String = "PVE"



func assign_settings_to_the_game(parameters : Dictionary):
	parameters["number_of_opponents"] = number_of_opponents
	parameters["dimx"]=dimx
	parameters["dimy"]=dimy
	parameters["game_mode"]=game_mode
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
