extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Obtenir la caméra active
	var camera = get_viewport().get_camera_2d()
	
	if camera:
		# Afficher la position de la caméra dans la console
		print("Position de la caméra:", camera.position)
		pass
