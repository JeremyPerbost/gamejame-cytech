extends Node2D

var marker_commun
var boost
var boost_special
var boost_durability
@onready var timer=$Timer_boost
@onready var timer_special=$Timer_boost_special
var temps_total = 120.0
var temps_ecouler = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	marker_commun=$Marker_commun
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func point_aleatoire(rayon: float)->Vector2:
	var angle = randf() * 2*PI  # TAU = 2 * PI
	var r = sqrt(randf()) * rayon  # Uniformisation du rayon
	var x = r * cos(angle)
	var y = r * sin(angle)
	return Vector2(x, y)
func _on_timer_timeout() -> void:
	var random_point=marker_commun.get_children().pick_random()
	var boost_scene = preload("res://maps/boost/boost.tscn")
	var boost_durability_scene = preload("res://maps/boost/boost_durability.tscn")
	var attaque = preload("res://maps/boost/attaque.tscn")
	var esquive = preload("res://maps/boost/esquive.tscn")
	var boost_death = preload("res://maps/boost/boost_death.tscn")
	# Génère un nombre aléatoire entre 0 et 99 (inclus)
	var random_number = randi() % 100
	var boost
	# Détermine quel boost à instancier en fonction des probabilités
	if random_number < 20:
		boost = boost_scene.instantiate()  # 20% pour boost_speed
	elif random_number < 40:
		boost = boost_durability_scene.instantiate()  # 20% pour boost_durability
	elif random_number < 65:
		boost = attaque.instantiate()  # 25% pour attaque
	elif random_number < 90:
		boost = esquive.instantiate()  # 25% pour esquive
	else:
		boost = boost_death.instantiate()  # 10% pour boost_death
	# Génère une position aléatoire pour le boost
	var random_position = point_aleatoire(Arene.taille)
	boost.global_position = random_position
	get_parent().add_child(boost)
	temps_ecouler += timer.wait_time  # Augmente le temps écoulé
	var progress = min(1, temps_ecouler / temps_total)  # Progression entre 0 et 1
	timer.wait_time = 4 + (0.5 - 4)* progress
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
