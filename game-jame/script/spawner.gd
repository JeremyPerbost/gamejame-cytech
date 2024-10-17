extends Node2D

var marker
var boost
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	marker=$Marker
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var random_point=marker.get_children().pick_random()
	var boost_scene=preload("res://maps/boost.tscn")
	boost=boost_scene.instantiate()
	boost.global_position=random_point.global_position
	get_parent().add_child(boost)
	pass 

	
	
	
	


func _on_timer_boost_disparaitre_timeout() -> void:
	boost.queue_free()
	pass # Replace with function body.
