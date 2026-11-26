extends Node

var enemy

var current_stage
var ship_setup_UI
enum GamePhase
{
	PLACEMENT,
	GAME,
	FINISH	
}

func setup(ssUI):
	ship_setup_UI=ssUI
	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		
		pass # Replace with function body.

func start():
	setup_ships()
	pass

func setup_ships():
	current_stage=GamePhase.PLACEMENT
	ship_setup_UI.visible=true
	pass

func begin_shooting():
	current_stage=GamePhase.GAME
	
func end_game():
	current_stage=GamePhase.FINISH


func indicate_ready():
	pass

func get_current_stage():
	return current_stage
