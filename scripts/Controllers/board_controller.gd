extends Node

var player_boards : Dictionary
var player_controller
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setup(s_player_controller):
	player_controller=s_player_controller



func setup_boards(map_sizes : Dictionary) -> void:
	#This is how many players are in the game
	#Each player was saved in the dictionary in player controller
	#Each of them will now receive a board
	var player_board: PlayerBoard
	var players=player_controller.players
	for player_id in player_controller.players:
		player_board = PlayerBoard.new()
		player_board.id= player_id
		
		var dict_id = str("map_",player_id)
		player_board.size=map_sizes[dict_id]
		#it does not have to be the same ID
		#It is just convenient to have some iterating value already in the loop
		player_board.owner_id=player_id  #!ATTENTION! THIS IS IMPORTANT
		player_boards[player_board.owner_id]=player_board #Get them into dictionary
		player_board.generate_array()


func get_board_by_owner(owner_id:int):
	return player_boards[owner_id]
