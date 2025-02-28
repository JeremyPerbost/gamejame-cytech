extends Node2D  # Ou Control si tu utilises une interface UI

var TOT = 180
var total_time = TOT
var is_game_running = true

@onready var transition_round = $transition_round
@onready var toupie2 = $Area_arene/Area_toupie2
@onready var toupie1 = $Area_arene/Area_toupie1
@onready var score_tp1 = $score_tp1
@onready var score_tp2 = $score_tp2
@onready var pause_menu = $pause
@onready var audio_combat1=$audio_combat1
@onready var audio_combat2=$audio_combat2
@onready var audio_combat3=$audio_combat3
@onready var audio_transition_round=$audio_transition_round
@onready var background=$Background1
@onready var sand_wind=$sand_wind
@onready var rain=$rain
@onready var stars=$stars
var is_transition_playing = false

func play_musique():
	#choisir quelle musique jouer
	if Score.score_player1 == 0 and Score.score_player2 == 0:
		MusiqueManager.jouer(load("res://sons/combat/combat_1_loop.mp3"))
	elif (Score.score_player1 == 1 and Score.score_player2 in [0, 1]) or (Score.score_player2 == 1 and Score.score_player1 == 0):
		MusiqueManager.jouer(load("res://sons/combat/combat_2_loop.mp3"))
	elif (Score.score_player1 in [1, 2] and Score.score_player2 in [1, 2]) or (Score.score_player1 == 2 and Score.score_player2 == 0) or (Score.score_player2 == 2 and Score.score_player1 == 0):
		MusiqueManager.jouer(load("res://sons/combat/combat_3_loop.mp3"))
	pass
func _ready():
	gestion_effet_arene()
	Score.is_transition_playing=false
	background.texture = load(Arene.arene)
	score_tp1.visible = false
	score_tp2.visible = false
	play_musique()
	
func start_game():
	
	is_game_running = true

func play_transition_animation() -> void:
	if not is_transition_playing:
		Score.is_transition_playing=true
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
		if $Time.time_left==0:
			is_game_running = false
			egalite()
		elif Input.is_action_pressed("pause") || Input.is_action_just_pressed("ui_p1_pause"):
			pause()
		if total_time > 0:
			total_time -= delta
		else:
			is_game_running = false
			game_over(0)
		if Score.score_player1 == 3:
			is_game_running = false
			game_over(1)
		elif Score.score_player2 == 3:
			is_game_running = false
			game_over(2)

func game_over(condition_fin_jeu : int):
	Score.is_transition_playing=true
	if condition_fin_jeu == 0:
		print("FIN DU JEU PLUS DE TEMPS")
		TransitionScreen.transition("res://maps/EndGame.tscn")
		print("EGALITER")
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
func egalite() -> void:
	if not is_transition_playing:
		Score.is_transition_playing=true
		audio_transition_round.play()
		await get_tree().create_timer(8.0).timeout 
		get_tree().reload_current_scene()
func gestion_effet_arene():
	if Arene.arene=="res://images/Menus/background/background_combat_sand.png":
		sand_wind.emitting=true
		rain.emitting=false
		stars.emitting=false
	if Arene.arene=="res://images/Menus/background/background_combat_pierre.png":
		sand_wind.emitting=false
		rain.emitting=true
		stars.emitting=false
	if Arene.arene=="res://images/Menus/background/background_combat_space.png":
		sand_wind.emitting=false
		rain.emitting=false
		stars.emitting=true
	else:
		sand_wind.emitting=false
		rain.emitting=false
		stars.emitting=false
