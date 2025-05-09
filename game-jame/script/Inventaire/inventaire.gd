extends Node2D

var boost1_P1
var boost2_P1
var boost3_P1

var boost1_P2
var boost2_P2
var boost3_P2

var marker1P1
var marker2P1
var marker3P1
var marker1P2
var marker2P2
var marker3P2

func _ready() -> void:
	marker1P1 = $HBoxContainer/inventaire_P1/place1_P1
	marker2P1 = $HBoxContainer/inventaire_P1/place2_P1
	marker3P1 = $HBoxContainer/inventaire_P1/place3_P1
	marker1P2 = $HBoxContainer/inventaire_P2/place1_P2
	marker2P2 = $HBoxContainer/inventaire_P2/place2_P2
	marker3P2 = $HBoxContainer/inventaire_P2/place3_P2

func mettre_a_jour_boost(place: String, boost_ref: Node, marker: Node2D) -> Node:
	if boost_ref != null and not boost_ref.is_queued_for_deletion():
		boost_ref.queue_free()
	if place == "attaque":
		var boost_attaque = preload("res://maps/UI_joueur/boost_attaque.tscn")
		if boost_attaque == null:
			print("Erreur : boost_attaque.tscn introuvable")
			return null
		var new_boost = boost_attaque.instantiate()
		new_boost.global_position = marker.global_position
		get_parent().add_child(new_boost)
		return new_boost
	elif place == "esquive":
		var boost_esquive = preload("res://maps/UI_joueur/boost_esquive.tscn")
		if boost_esquive == null:
			print("Erreur : boost_esquive.tscn introuvable")
			return null
		var new_boost = boost_esquive.instantiate()
		new_boost.global_position = marker.global_position
		get_parent().add_child(new_boost)
		return new_boost
	elif place == "death":
		var boost_death = preload("res://maps/UI_joueur/ui_boost_death.tscn")
		if boost_death == null:
			print("Erreur : ui_boost_death introuvable")
			return null
		var new_boost = boost_death.instantiate()
		new_boost.global_position = marker.global_position
		get_parent().add_child(new_boost)
		return new_boost
	elif place == "vide":
		return null
	return null
func _process(delta: float) -> void:
	if Parametres.Speed_bar==true:
		$HBoxContainer/inventaire_P1/barre_de_vie_p1.visible=true
		$HBoxContainer/inventaire_P2/barre_de_vie_p2.visible=true
	else:
		$HBoxContainer/inventaire_P1/barre_de_vie_p1.visible=false
		$HBoxContainer/inventaire_P2/barre_de_vie_p2.visible=false		
	var anim_p1 = $HBoxContainer/inventaire_P1/barre_de_vie_p1/Animation_barre_p1
	var anim_p2 = $HBoxContainer/inventaire_P2/barre_de_vie_p2/Animation_barre_p2
	if anim_p2.has_animation("anim_barre_p1"):
		anim_p2.play("anim_barre_p1")
	if anim_p1.has_animation("anim_barre_p1"):
		anim_p1.play("anim_barre_p1")
	var speed_normalized1 = clamp(Score.curent_speed_p1 /Arene.init_speed, 0, 1)  # Garde entre 0 et 1
	var speed_normalized2 = clamp(Score.curent_speed_p2 /Arene.init_speed, 0, 1)  # Garde entre 0 et 1
	anim_p2.seek(1-speed_normalized2, true)  # Met l'animation à la bonne position
	anim_p1.seek(1-speed_normalized1, true)  # Met l'animation à la bonne position
	raffraichir_inventaire()
func raffraichir_inventaire() -> void:
	boost1_P1 = mettre_a_jour_boost(P1Inventaire.place1, boost1_P1, marker1P1)
	boost2_P1 = mettre_a_jour_boost(P1Inventaire.place2, boost2_P1, marker2P1)
	boost3_P1 = mettre_a_jour_boost(P1Inventaire.place3, boost3_P1, marker3P1)

	boost1_P2 = mettre_a_jour_boost(P2Inventaire.place1, boost1_P2, marker1P2)
	boost2_P2 = mettre_a_jour_boost(P2Inventaire.place2, boost2_P2, marker2P2)
	boost3_P2 = mettre_a_jour_boost(P2Inventaire.place3, boost3_P2, marker3P2)
