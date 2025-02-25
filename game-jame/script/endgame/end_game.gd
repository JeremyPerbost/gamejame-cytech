extends Node2D

var player1_title = preload("res://images/ecran_de_fin/player1win.png")
var player2_title = preload("res://images/ecran_de_fin/player2win.png")
@onready var replay_button = $rejouer_btn as Button#0
@onready var title_btn = $ecran_titre_btn as Button#1
var bouton_selectionner=0
var rotate_speed : float =0.04
func _ready() -> void:
	$Statistique/HBoxContainer/Stat_player1/label_vitesse_max_P1.text = "max speed : " + str(Score.max_speed_player1/100)+" KM/H"
	$Statistique/HBoxContainer/Stat_player1/label_distanceP1.text="distance traveled : "+str(Score.distanceP1/100)+" M"
	$Statistique/HBoxContainer/Stat_player1/label_nombre_de_boosters_speciauxP1.text="number of special boosts used:"+str(Score.nbr_booster_speciauxP1)
	$Statistique/HBoxContainer/Stat_player1/label_nombre_de_boosters_communsP1.text="number of common boosters used: "+str(Score.nbr_booster_communP1)
	$Statistique/HBoxContainer/Stat_player1/label_toucher_bords_P1.text="touch the edge of the arena "+str(Score.nbr_bordsP1)+" times"

	print("Score.gagnant="+Score.gagnant)
	if Score.gagnant == "player1":
		$player_title.texture = player1_title
		$toupie_gagnante.texture = load(Skins.P1)
	elif Score.gagnant == "player2":
		$player_title.texture = player2_title
		$toupie_gagnante.texture =load(Skins.P2)
	else:
		print("ERREUR PAS DE GAGNANT !")
	await $Animation_endgame.animation_finished
	$Price.play("default")
	await $Price.animation_finished
	$Price.play_backwards("default")
	pass # Replace with function body.
func selectionner_bouton():
	if bouton_selectionner==0:
		replay_button.grab_focus()
		title_btn.release_focus()
	elif bouton_selectionner==1:
		title_btn.grab_focus()
		replay_button.release_focus()
func _process(delta: float) -> void:
	$toupie_gagnante.rotation +=rotate_speed* delta
	if Input.is_action_just_pressed("ui_p1_up") and bouton_selectionner==1:
		bouton_selectionner=0
		selectionner_bouton()
	if Input.is_action_just_pressed("ui_p1_down") and bouton_selectionner==0:
		bouton_selectionner=1
		selectionner_bouton()
	if Input.is_action_just_pressed("ui_p1_A"):
		if bouton_selectionner==0:
			_on_rejouer_btn_pressed()
		elif bouton_selectionner==1:
			_on_ecran_titre_btn_pressed()
	pass
func _on_ecran_titre_btn_pressed() -> void:
	TransitionScreen.transition("res://maps/menuprincipal.tscn")
	pass # Replace with function body.


func _on_rejouer_btn_pressed() -> void:
	Score.score_player1=0
	Score.score_player2=0
	Score.gagnant=""
	TransitionScreen.transition("res://maps/toupie.tscn")
	pass # Replace with function body.
