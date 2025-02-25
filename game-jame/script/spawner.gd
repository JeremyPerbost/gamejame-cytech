extends Node2D

var marker_commun
var boost
var boost_special
var boost_durability
@onready var timer_special=$Timer_boost_special
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	marker_commun=$Marker_commun
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var random_point=marker_commun.get_children().pick_random()
	var boost_scene=preload("res://maps/boost/boost.tscn")
	var boost_durability_scene=preload("res://maps/boost/boost_durability.tscn")
	var random_number = randi() % 4
	if random_number == 0:
		boost = boost_scene.instantiate()
		boost.global_position = random_point.global_position
		get_parent().add_child(boost)
	elif random_number == 1:
		boost = boost_durability_scene.instantiate()
		boost.global_position = random_point.global_position
		get_parent().add_child(boost)
	else:
		pass

	
	
	
	


func _on_timer_boost_disparaitre_timeout() -> void:
	if boost:  # Vérifie si 'boost' n'est pas nul
		boost.queue_free()
		boost = null  # Optionnel : réinitialise 'boost' pour éviter des références à un objet supprimé
	pass  # Remplacer par le corps de la fonction si nécessaire.



func _on_timer_boost_special_timeout() -> void:
	var boost_trounoir=preload("res://maps/boost/boost_trounoir.tscn")
	var boost_invincible=preload("res://maps/boost/boost_invincible.tscn")
	var boost_piege=preload("res://maps/boost/boost_piege.tscn")
	timer_special.wait_time = randi() % 14 + 15
	print("prochaine apparition boost special=", timer_special.wait_time)
	var random_number = randi() % 4
	if random_number == 0:
		boost_special = boost_trounoir.instantiate()
		boost_special.global_position = Vector2(0, 0)
		get_parent().add_child(boost_special)
	elif random_number == 1:
		boost_special = boost_invincible.instantiate()
		boost_special.global_position = Vector2(0, 0)
		get_parent().add_child(boost_special)
	if random_number == 3:
		boost_special = boost_piege.instantiate()
		boost_special.global_position = Vector2(0, 0)
		get_parent().add_child(boost_special)
	timer_special.start()	
	pass # Replace with function body.
