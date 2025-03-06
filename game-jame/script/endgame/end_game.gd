extends Node2D

var player1_title = preload("res://images/ecran_de_fin/player1win.png")
var player2_title = preload("res://images/ecran_de_fin/player2win.png")
@onready var replay_button = $rejouer_btn as Button#0
@onready var title_btn = $ecran_titre_btn as Button#1
var bouton_selectionner=0
var rotate_speed : float =0.04
func _ready() -> void:
	Score.nbr_parties=Score.nbr_parties+1
	if Score.mode_de_jeu==1:#solo
		Score.nbr_parties_ia=Score.nbr_parties_ia+1
		if Score.gagnant == "player1":#humain gagne
			Score.nbr_parties_gagnees_ia=Score.nbr_parties_gagnees_ia+1
	if Score.max_speed_player1>Score.max_speed_tot:
		Score.max_speed_tot=Score.max_speed_player1
	if Score.max_speed_player2>Score.max_speed_tot:
		Score.max_speed_tot=Score.max_speed_player2
	Score.total_distance_p1=Score.total_distance_p1+(Score.distanceP1 / 100000.0)
	Score.total_distance_p2=Score.total_distance_p2+(Score.distanceP2 / 100000.0)
	SaveManager.Save()
	MusiqueManager.stop()
	$audio_EndGameStart.play()
	$Statistique/Stat_player1/label_vitesse_max_P1.text = "max speed : %.1f KM/H" % (Score.max_speed_player1 / 100.0)
	$Statistique/Stat_player1/label_distanceP1.text = "distance traveled : %.1f M" % (Score.distanceP1 / 100.0)
	$Statistique/Stat_player1/label_nombre_de_boosters_speciauxP1.text = "number of special boosts used: %d" % Score.nbr_booster_speciauxP1
	$Statistique/Stat_player1/label_nombre_de_boosters_communsP1.text = "number of common boosters used: %d" % Score.nbr_booster_communP1
	$Statistique/Stat_player1/label_toucher_bords_P1.text = "touch the edge of the arena %d times" % Score.nbr_bordsP1

	$Statistique/Stat_player2/label_vitesse_max_P2.text = "max speed : %.1f KM/H" % (Score.max_speed_player2 / 100.0)
	$Statistique/Stat_player2/label_distanceP2.text = "distance traveled : %.1f M" % (Score.distanceP2 / 100.0)
	$Statistique/Stat_player2/label_nombre_de_boosters_speciauxP2.text = "number of special boosts used: %d" % Score.nbr_booster_speciauxP2
	$Statistique/Stat_player2/label_nombre_de_boosters_communsP2.text = "number of common boosters used: %d" % Score.nbr_booster_communP2
	$Statistique/Stat_player2/label_toucher_bords_P2.text = "touch the edge of the arena %d times" % Score.nbr_bordsP2

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
		replay_button.modulate=Color(0,3,0,2)
		title_btn.modulate=Color(1,1,1,1)
	elif bouton_selectionner==1:
		replay_button.modulate=Color(1,1,1,1)
		title_btn.modulate=Color(0,3,0,2)
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
	Score.score_player1=0
	Score.score_player2=0
	SaveManager.Save()
	TransitionScreen.transition("res://maps/menuprincipal.tscn")
	pass # Replace with function body.
func _on_rejouer_btn_pressed() -> void:
	Score.score_player1=0
	Score.score_player2=0
	Score.gagnant=""
	if Skins.P1=="res://images/skins/ia.png":
		Skins.P1="res://images/skins/P1.png"
	if Skins.P2=="res://images/skins/ia.png":
		Skins.P2="res://images/skins/P2.png"
	TransitionScreen.transition("res://maps/toupie.tscn")
	pass # Replace with function body.


func _on_audio_end_game_start_finished() -> void:
	$audio_EndGame.play()
	pass # Replace with function body.
