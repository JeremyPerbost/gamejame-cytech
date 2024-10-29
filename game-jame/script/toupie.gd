extends Node2D  # Ou Control si tu utilises une interface UI

# Temps total du timer en secondes (3 minutes)
var TOT=180
var total_time = TOT
var is_game_running = true  # Indique si la partie est en cours

static var score_player1 = 0 
static var score_player2 = 0

# Référence au label pour afficher le temps
var timer_label  # Déclare la variable ici pour qu'elle soit accessible partout

func _ready():
	# Initialisation de la référence au label "temps_affichage"
	timer_label = get_node("./temps_affichage")
	update_timer_display()

# Fonction pour démarrer la partie et le timer
func start_game():
	is_game_running = true

# Cette fonction est appelée à chaque frame
func _process(delta):
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
	if condition_fin_jeu == 0 :
		timer_label.text = "Time's up!"
	elif condition_fin_jeu == 1:
		print("Player one won")
	elif condition_fin_jeu == 2:
		print("Player two won")
	# Ici, tu peux ajouter des actions pour finir la partie


func _on_area_toupie_1_winner_round(winner: String) -> void:
	print(winner +" won the round")
	score_player2+=1
	print("score player 2 "+str(score_player2))

	get_tree().reload_current_scene()
	


func _on_area_toupie_2_winner_round(winner: String) -> void:
	print(winner +" won the round")
	score_player1+=1
	print("score player 1 "+str(score_player1))
	get_tree().reload_current_scene()
