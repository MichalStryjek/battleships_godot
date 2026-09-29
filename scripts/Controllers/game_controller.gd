extends Node

var enemy
var secret_board

var current_stage
enum GamePhase


{
	PLACEMENT,
	GAME,
	FINISH
	
	
}

func setup():
	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		
		pass # Replace with function body.

func start():
	pass

func setup_ships():
	current_stage=GamePhase.PLACEMENT
	pass

func begin_shooting():
	current_stage=GamePhase.GAME
	
func end_game():
	current_stage=GamePhase.FINISH


func indicate_ready():
	pass
