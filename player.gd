class_name Player
extends Node

var player_id
var assigned_board
var pieces_set
var state : PlayerState

enum PlayerState{
	
ALIVE,
DEFEATED	

}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
