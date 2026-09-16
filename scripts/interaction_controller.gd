extends Node3D

@onready var camera_controller = $"../CameraController"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func raycast_from_camera(mouse_pos: Vector2):
	var object_hit
	var camera = camera_controller.get_camera()
	###For debugging the returned results are broader
	###print ("mouse: ",mouse_pos)
	var from = camera.project_ray_origin(mouse_pos)
	###Indicate beginning point of the ray
	###print ("ray origin: ", from)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000.0
	###Indicate target of the rey. It is somewhere far away. Clicked object should be somewhere before the end point.
	var query = PhysicsRayQueryParameters3D.create(from, to)
	###This prepares parameters for the shooting
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	#print("LOG: raycast result ", result)
	return result

# Called every frame. 'delta' is the elapsed time since the previous frame.
func handle_click_interaction(position):
	var result = raycast_from_camera(position)
	
	if result.is_empty():
		return
	
	var object = result.collider
	
	if object.has_method("interact"):
		object.intereact()
	
	elif object is GridMap:
		print("Pszczółka")
	return
