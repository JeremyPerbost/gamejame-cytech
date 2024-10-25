extends Node2D

var marker_commun
var boost
var boost_durability
@onready var timer_trounoir=$Timer_trounoir
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


func _on_timer_trounoir_timeout() -> void:
	# Génère un temps aléatoire entre 2 et 10 secondes à chaque fin de Timer
	var boost_trounoir=preload("res://maps/boost_trounoir.tscn")
	timer_trounoir.wait_time = randi() % 11 + 10  # 11 pour inclure 20, et 10 pour le décalage
	print("prochaine apparition trou noir=", timer_trounoir.wait_time)
	boost = boost_trounoir.instantiate()
	boost.global_position = Vector2(0, 0)
	get_parent().add_child(boost)
	timer_trounoir.start()

	pass # Replace with function body.
