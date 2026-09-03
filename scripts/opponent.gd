class_name opponent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var secret_board = generate_game_array()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func generate_game_array():
	var grid = [
		
		[1,1,1,1,1,1,1,1,1,2],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,2,2,2,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,2]
	]
	return grid
