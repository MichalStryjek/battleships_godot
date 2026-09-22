extends Node

var player
var players : Dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initiate_players(number_of_opponents):
	for i in range(number_of_opponents+1):
		player=Player.new()
		player.player_id=i
		player.state=player.PlayerState.ALIVE
		players[player.player_id]=player
		
func get_player(player_id: int) -> Player:
	return players.get(player_id)
