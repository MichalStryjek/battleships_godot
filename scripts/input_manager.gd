extends Node

var camera_controller
var interaction_controller
var target_maps

func setup(s_camera_controller, s_interaction_controller, s_target_maps):
	camera_controller=s_camera_controller
	interaction_controller=s_interaction_controller
	target_maps=s_target_maps
	
func _input(event):
	if event.is_action_pressed("camera_pan"):
		#print(camera_shoot.position)
		camera_controller.switch_pan()
		
	if event.is_action_pressed("switch_map_left"):
		camera_controller.move_maps("left")
		
		
	if event.is_action_pressed("switch_map_right"):
		camera_controller.move_maps("right")
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interaction_controller.handle_click_interaction(event.position)
			#Returns the cell that a ray passing through mouse and camera collided with. It basically says where player intended to click.
	if event  is InputEventMouseMotion:
		interaction_controller.handle_hover(event.position)
