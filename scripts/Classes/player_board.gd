class_name PlayerBoard
#Its a class for underlying state for a player board regardless of player
#It is different than player map that represents game display from the point
#of view of current player
extends Node

var id : int
var owner_id: int
var size
var map : Array[Array]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func generate_array():
	for i in range(size):
		var column = []
		for j in range(size):
			column.append(0) 
		map.append(column)
