extends Node2D  # Ou Control si tu utilises une interface UI

# Temps total du timer en secondes (3 minutes)
var TOT = 180
var total_time = TOT
var is_game_running = true  # Indique si la partie est en cours

static var score_player1 = 0 
static var score_player2 = 0
@onready var transition_round = $transition_round
@onready var timer_label = $temps_affichage  # Référence au label pour afficher le temps
@onready var toupie2 = $Area_arene/Area_toupie2
@onready var toupie1 = $Area_arene/Area_toupie1
var is_transition_playing = false  # Vérifie si l'animation est en cours de lecture
func _ready():
	update_timer_display()

# Fonction pour démarrer la partie et le timer
func start_game():
	is_game_running = true

# Joue l'animation de transition une seule fois
func play_transition_animation() -> void:
	if not is_transition_playing:  # Vérifie que l'animation n'est pas déjà en cours
		is_transition_playing = true
		print("JOUER ANIMATION TRANSITION")
		transition_round.play("default")
		print("FIN ANIMATION TRANSITION")
func affichage_score() -> void:
		toupie2.position = Vector2(-350, 0)
		toupie2.z_index=10
		toupie1.position = Vector2(350, 0)
		toupie1.z_index=10
func _process(delta):
	if is_transition_playing:
		affichage_score()
	if is_game_running:
		# Décompte le temps si le jeu est en cours
		if total_time > 0:
			total_time -= delta  # Réduit le temps par le delta (temps écoulé entre les frames)
			update_timer_display()
		else:
			is_game_running = false  # Arrête le jeu quand le temps est écoulé
			game_over(0)
		if score_player1 == 2:
			is_game_running = false
			game_over(1)
			get_tree().quit()
		elif score_player2 == 2:
			is_game_running = false
			game_over(2)
			get_tree().quit()

# Met à jour l'affichage du temps sur le label
func update_timer_display():
	var minutes = int(total_time) / 60
	var seconds = int(total_time) % 60
	timer_label.text = str(minutes) + ":" + str(seconds).pad_zeros(2)

# Fonction appelée quand le temps est écoulé
func game_over(condition_fin_jeu : int):
	if condition_fin_jeu == 0:
		timer_label.text = "Time's up!"
	elif condition_fin_jeu == 1:
		print("Player one won")
	elif condition_fin_jeu == 2:
		print("Player two won")

func _on_area_toupie_1_winner_round(winner: String) -> void:
	if not is_transition_playing:  # Assure que l'animation est jouée une seule fois
		print(winner + " won the round")
		score_player2 += 1
		print("Score player 2: " + str(score_player2))
		play_transition_animation()
		await get_tree().create_timer(8.0).timeout 
		get_tree().reload_current_scene()
func _on_area_toupie_2_winner_round(winner: String) -> void:
	if not is_transition_playing:  # Assure que l'animation est jouée une seule fois
		print(winner + " won the round")
		score_player1 += 1
		print("Score player 1: " + str(score_player1))
		play_transition_animation()
		await get_tree().create_timer(8.0).timeout 
		get_tree().reload_current_scene()
