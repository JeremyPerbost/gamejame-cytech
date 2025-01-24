extends Node2D  # Ou Control si tu utilises une interface UI

var TOT = 180
var total_time = TOT
var is_game_running = true

@onready var transition_round = $transition_round
@onready var timer_label = $temps_affichage
@onready var toupie2 = $Area_arene/Area_toupie2
@onready var toupie1 = $Area_arene/Area_toupie1
@onready var score_tp1 = $score_tp1
@onready var score_tp2 = $score_tp2
@onready var pause_menu = $pause
@onready var audio_combat1=$audio_combat1
@onready var audio_combat2=$audio_combat2
@onready var audio_combat3=$audio_combat3
@onready var audio_transition_round=$audio_transition_round
var is_transition_playing = false
func play_musique():
	#choisir quelle musique jouer
	if (Score.score_player1+Score.score_player2<=0):
		audio_combat1.play()
	elif ((Score.score_player1+Score.score_player2==1)||((Score.score_player1==Score.score_player2) &&(Score.score_player2==1))) :
		audio_combat2.play()
	else:
		audio_combat3.play()
	pass
func _ready():
	update_timer_display()
	score_tp1.visible = false
	score_tp2.visible = false
	play_musique()
	
func start_game():
	
	is_game_running = true

func play_transition_animation() -> void:
	if not is_transition_playing:
		is_transition_playing = true
		print("JOUER ANIMATION TRANSITION")
		P1Inventaire.place1="vide"
		P1Inventaire.place2="vide"
		P1Inventaire.place3="vide"
		score_tp1.visible = true
		score_tp2.visible = true
		score_tp1.text = str(Score.score_player1)
		score_tp2.text = str(Score.score_player2)
		transition_round.play("default")
		print("FIN ANIMATION TRANSITION")

func affichage_score() -> void:
	toupie2.position = Vector2(-350, 0)
	toupie2.z_index = 10
	toupie1.position = Vector2(350, 0)
	toupie1.z_index = 10
func pause():
	print("PAUSE")
	get_tree().paused = true
	pause_menu.show()
func _process(delta):
	if is_transition_playing:
		affichage_score()
	if is_game_running:
		if Input.is_action_pressed("pause"):
			pause()
		if total_time > 0:
			total_time -= delta
			update_timer_display()
		else:
			is_game_running = false
			game_over(0)
		if Score.score_player1 == 3:
			is_game_running = false
			game_over(1)
		elif Score.score_player2 == 3:
			is_game_running = false
			game_over(2)

func update_timer_display():
	var minutes = int(total_time) / 60
	var seconds = int(total_time) % 60
	timer_label.text = str(minutes) + ":" + str(seconds).pad_zeros(2)

func game_over(condition_fin_jeu : int):
	if condition_fin_jeu == 0:
		timer_label.text = "Time's up!"
	elif condition_fin_jeu == 1:
		print("Player one won")
		Score.gagnant="player1"
		TransitionScreen.transition("res://maps/EndGame.tscn")
	elif condition_fin_jeu == 2:
		print("Player two won")
		Score.gagnant="player2"
		TransitionScreen.transition("res://maps/EndGame.tscn")

func _on_area_toupie_1_winner_round(winner: String) -> void:
	if not is_transition_playing:
		print(winner + " won the round")
		Score.score_player2 += 1
		print("Score player 2: " + str(Score.score_player2))
		play_transition_animation()
		audio_transition_round.play()
		await get_tree().create_timer(8.0).timeout 
		get_tree().reload_current_scene()

func _on_area_toupie_2_winner_round(winner: String) -> void:
	if not is_transition_playing:
		print(winner + " won the round")
		Score.score_player1 += 1
		print("Score player 1: " + str(Score.score_player1))
		play_transition_animation()
		audio_transition_round.play()
		await get_tree().create_timer(8.0).timeout 
		get_tree().reload_current_scene()
