extends Control

var boost1
var boost2
var boost3

var marker1
var marker2
var marker3

func _ready() -> void:
	marker1 = $HBoxContainer/inventaire_P1/place1_P1
	marker2 = $HBoxContainer/inventaire_P1/place2_P1
	marker3 = $HBoxContainer/inventaire_P1/place3_P1
#cette fonction permet d'assurer l'affichage correct de l'inventaire. 
#TOUT LE CODE PRESENT ICI N'EST QUE D'UTILITER GRAPHIQUE !!!
func _process(delta: float) -> void:
	raffraichir_inventaire()
	pass
func _on_timer_p_1_timeout() -> void:
	var rng = RandomNumberGenerator.new() 
	var choix = rng.randi_range(0, 1)
	if boost3!=null:
		print("TOUT EST REMPLI")
	elif boost2!=null:
		if choix==0:
			P1Inventaire.place3="attaque"
		else:
			P1Inventaire.place3="esquive"
	elif boost1!=null:
		if choix==0:
			P1Inventaire.place2="attaque"
		else:
			P1Inventaire.place2="esquive"
	elif boost1==null:
		if choix==0:
			P1Inventaire.place1="attaque"
		else:
			P1Inventaire.place1="esquive"
# Fonction générique pour mettre à jour un boost
func mettre_a_jour_boost(place: String, boost_ref: Node, marker: Node2D) -> Node:
	if boost_ref != null:
		boost_ref.queue_free()  # Supprime l'ancien boost

	if place == "attaque":
		var boost_attaque = preload("res://maps/UI_joueur/boost_attaque.tscn")
		var new_boost = boost_attaque.instantiate()
		new_boost.global_position = marker.global_position
		get_parent().add_child(new_boost)
		return new_boost
	elif place == "esquive":
		var boost_esquive = preload("res://maps/UI_joueur/boost_esquive.tscn")
		var new_boost = boost_esquive.instantiate()
		new_boost.global_position = marker.global_position
		get_parent().add_child(new_boost)
		return new_boost
	elif place == "vide":
		return null
	return null

# Fonction principale pour rafraîchir l'inventaire
func raffraichir_inventaire() -> void:
	# Met à jour les boosts pour chaque place
	boost1 = mettre_a_jour_boost(P1Inventaire.place1, boost1, marker1)
	boost2 = mettre_a_jour_boost(P1Inventaire.place2, boost2, marker2)
	boost3 = mettre_a_jour_boost(P1Inventaire.place3, boost3, marker3)

	#print("---Inventaire---")
	#print(P1Inventaire.place1)
	#print(P1Inventaire.place2)
	#print(P1Inventaire.place3)
