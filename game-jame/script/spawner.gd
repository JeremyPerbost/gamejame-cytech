extends Node2D

var marker_commun
var boost
var boost_durability
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	marker_commun=$Marker_commun
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var random_point=marker_commun.get_children().pick_random()
	var boost_scene=preload("res://maps/boost.tscn")
	var boost_durability_scene=preload("res://maps/boost_durability.tscn")
	if randi() % 2 == 0:
		boost = boost_durability_scene.instantiate()
	else:
		boost = boost_durability_scene.instantiate()
	boost.global_position=random_point.global_position
	get_parent().add_child(boost)
	pass 

	
	
	
	


func _on_timer_boost_disparaitre_timeout() -> void:
	boost.queue_free()
	pass # Replace with function body.
