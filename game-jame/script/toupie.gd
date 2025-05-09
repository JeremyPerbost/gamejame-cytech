extends Node2D  # Ou Control si tu utilises une interface UI

var TOT = Arene.temps
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
@onready var darkness_song=$audio_darkness_song
var is_transition_playing = false
var dark_arene=false#ajouter le mode jour-nuit a l'arene
var compteur_darkness=0

func _ready():
	gestion_effet_arene()
	Score.is_transition_playing=false
	background.texture = load(Arene.arene)
	score_tp1.visible = false
	score_tp2.visible = false
	
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
		P2Inventaire.place1="vide"
		P2Inventaire.place2="vide"
		P2Inventaire.place3="vide"
		score_tp1.visible = true
		score_tp2.visible = true
		score_tp1.text = str(Score.score_player1)
		score_tp2.text = str(Score.score_player2)
		#transition_round.play("default")
		TransitionRound.transition("res://maps/toupie.tscn")
		print("FIN ANIMATION TRANSITION")

func affichage_score() -> void:
	toupie2.position = Vector2(-350, 0)
	toupie2.z_index = 10
	toupie1.position = Vector2(350, 0)
	toupie1.z_index = 10
func pause():
	print("PAUSE")
	if Score.score_player1 == 0 and Score.score_player2 == 0:
		MusiqueManager.jouer(load("res://sons/musiques/pause/combat_1_loop_menu.mp3"))
	elif (Score.score_player1 == 1 and Score.score_player2 in [0, 1]) or (Score.score_player2 == 1 and Score.score_player1 == 0):
		MusiqueManager.jouer(load("res://sons/musiques/pause/combat_2_loop_menu.mp3"))
	elif (Score.score_player1 in [1, 2] and Score.score_player2 in [1, 2]) or (Score.score_player1 == 2 and Score.score_player2 == 0) or (Score.score_player2 == 2 and Score.score_player1 == 0):
		MusiqueManager.jouer(load("res://sons/musiques/pause/combat_3_loop_menu.mp3"))
	get_tree().paused = true
	pause_menu.show()
func _process(delta):
	if is_transition_playing:
		affichage_score()
	if is_game_running:
		if $Time.time_left<=0:
			is_game_running = false
			egalite()
		elif Input.is_action_pressed("pause") || Input.is_action_just_pressed("ui_p1_pause"):
			pause()
		if total_time > 0:
			total_time -= delta
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
		TransitionRound.transition("res://maps/EndGame.tscn")
		print("EGALITER")
	elif condition_fin_jeu == 1:
		print("Player one won")
		Score.gagnant="player1"
		TransitionRound.transition("res://maps/EndGame.tscn")
	elif condition_fin_jeu == 2:
		print("Player two won")
		Score.gagnant="player2"
		TransitionRound.transition("res://maps/EndGame.tscn")

func _on_area_toupie_1_winner_round(winner: String) -> void:
	if not is_transition_playing:
		print(winner + " won the round")
		Score.score_player2 += 1
		print("Score player 2: " + str(Score.score_player2))
		play_transition_animation()
		audio_transition_round.play()

func _on_area_toupie_2_winner_round(winner: String) -> void:
	if not is_transition_playing:
		print(winner + " won the round")
		Score.score_player1 += 1
		print("Score player 1: " + str(Score.score_player1))
		play_transition_animation()
		audio_transition_round.play()
func egalite() -> void:
	if not is_transition_playing:
		play_transition_animation()
		audio_transition_round.play() 
		
func gestion_effet_arene():
	if Parametres.Effets==true:
		if Arene.arene=="res://images/Menus/background/background_combat_sand.png":
			sand_wind.emitting=true
			rain.emitting=false
			stars.emitting=false
			dark_arene=false
		elif Arene.arene=="res://images/Menus/background/background_combat_pierre.png":
			sand_wind.emitting=false
			rain.emitting=true
			stars.emitting=false
			dark_arene=false
		elif Arene.arene=="res://images/Menus/background/background_combat_space.png":
			sand_wind.emitting=false
			rain.emitting=false
			stars.emitting=true
			dark_arene=false
		elif Arene.arene=="res://images/Menus/background/background_combat_dark.png":
			sand_wind.emitting=false
			rain.emitting=false
			stars.emitting=false
			dark_arene=true
		else:
			sand_wind.emitting=false
			rain.emitting=false
			stars.emitting=false
			dark_arene=false
	else:
		if Arene.arene=="res://images/Menus/background/background_combat_dark.png":
			sand_wind.emitting=false
			rain.emitting=false
			stars.emitting=false
			dark_arene=true
		else:
			sand_wind.emitting=false
			rain.emitting=false
			stars.emitting=false
			dark_arene=false
		


func _on_dark_timer_timeout() -> void:
	if dark_arene==true:
		background.z_index=0
		compteur_darkness=compteur_darkness+1
		if compteur_darkness>=5:
			darkness_song.play()
			compteur_darkness=0
			background.z_index=34
	else:
		background.z_index=0
	pass # Replace with function body.
