extends Node

var screen := DisplayServer.window_get_current_screen()
var screen_size := DisplayServer.screen_get_size(screen)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:



	pass # Replace with function body.


func set_window_size():

	var window_size := Vector2i(
		int(screen_size.x * 0.7),
		int(screen_size.y * 0.7)
)

	DisplayServer.window_set_size(window_size)
