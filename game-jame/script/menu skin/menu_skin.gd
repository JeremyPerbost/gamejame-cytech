extends Control

const PLAYER1 = 0
const PLAYER2 = 1

var action_stack = []  # Gère l'ordre de sélection

enum SkinAvailables { RED, BLUE, WHITE, PURPLE, DUO, MILITARY, HUMAN, DEEP }

var game_skins = {
	SkinAvailables.RED: "P1.png",
	SkinAvailables.BLUE: "P2.png",
	SkinAvailables.WHITE: "skin1.png",
	SkinAvailables.PURPLE: "purple.png",
	SkinAvailables.DUO: "duo.png",
	SkinAvailables.MILITARY: "military.png",
	SkinAvailables.HUMAN: "human.png",
	SkinAvailables.DEEP: "blue2.png"
}

var chosen_skins = {
	PLAYER1: "P1.png",
	PLAYER2: "P2.png"
}

@onready var audio_selection = $audio_selection
@onready var audio_survolement = $audio_survolement
@onready var exit_bttn = $btn_menu
@onready var skin_panels = [
	$GridContainer/skin1,
	$GridContainer/skin2,
	$GridContainer/skin3,
	$GridContainer/skin4,
	$GridContainer/skin5,
	$GridContainer/skin6,
	$GridContainer/skin7,
	$GridContainer/skin8
]

var player_cursors = {PLAYER1: 0, PLAYER2: 0}  # Indice du skin sélectionné par chaque joueur
var navigation_delay = 0.02  # Délai pour éviter le spam
var navigation_timer = {PLAYER1: 0.0, PLAYER2: 0.0}  

var columns = 4  # Nombre de colonnes de la grille
var rows = 2  # Nombre de lignes (calculé automatiquement)
var numero_joueur = 0  # Alterne entre 0 et 1 pour gérer les sélections

func _ready() -> void:
	MusiqueManager.jouer(load("res://sons/musiques/menu_2_loop.mp3"))
	update_panels()

func _process(delta: float) -> void:
	# Mise à jour du timer pour chaque joueur
	navigation_timer[PLAYER1] += delta
	navigation_timer[PLAYER2] += delta

	# Gérer la navigation pour chaque joueur
	if navigation_timer[PLAYER1] >= navigation_delay:
		handle_navigation(PLAYER1, "ui_p1_left", "ui_p1_right", "ui_p1_up", "ui_p1_down", "ui_p1_A", "ui_p1_B")

	if navigation_timer[PLAYER2] >= navigation_delay:
		handle_navigation(PLAYER2, "ui_p2_left", "ui_p2_right", "ui_p2_up", "ui_p2_down", "ui_p2_A", "ui_p2_B")

### 🚀 **Gestion de la navigation pour chaque joueur** ###
func handle_navigation(player, left, right, up, down, accept, cancel):
	# Détection des boutons pour chaque manette
	if navigation_timer[player] < navigation_delay:
		return

	# Déplacement à gauche
	if Input.is_action_just_pressed(left):
		if player_cursors[player] % columns != 0:
			player_cursors[player] -= 1
			audio_survolement.play()
			update_panels()
			navigation_timer[player] = 0.0  

	# Déplacement à droite
	elif Input.is_action_just_pressed(right):
		if (player_cursors[player] + 1) % columns != 0 and player_cursors[player] + 1 < skin_panels.size():
			player_cursors[player] += 1
			audio_survolement.play()
			update_panels()
			navigation_timer[player] = 0.0  

	# Déplacement en haut (saut d'une ligne)
	elif Input.is_action_just_pressed(up):
		if player_cursors[player] - columns >= 0:
			player_cursors[player] -= columns
			audio_survolement.play()
			update_panels()
			navigation_timer[player] = 0.0  

	# Déplacement en bas (descend d'une ligne)
	elif Input.is_action_just_pressed(down):
		if player_cursors[player] + columns < skin_panels.size():
			player_cursors[player] += columns
			audio_survolement.play()
			update_panels()
			navigation_timer[player] = 0.0  

	# Sélection du skin
	if Input.is_action_just_pressed(accept):
		choose_skin(player, player_cursors[player])  # Appliquer le skin pour le joueur spécifique

	# Annuler un choix (retirer le skin du joueur)
	if Input.is_action_just_pressed(cancel):
		_on_btn_menu_pressed()

### **🌟 Mise à jour de l'affichage des skins** ###
func update_panels():
	for i in range(skin_panels.size()):
		var panel = skin_panels[i]
		var skin_texture = game_skins.values()[i]

		if chosen_skins[PLAYER1] == skin_texture:
			panel.self_modulate = Color(3, 0, 0, 2)
		elif chosen_skins[PLAYER2] == skin_texture:
			panel.self_modulate = Color(0, 3, 0, 2)
		else:
			panel.self_modulate = Color.BLACK
	# Indiquer le skin survolé par chaque joueur
	skin_panels[player_cursors[PLAYER1]].self_modulate = Color(2, 0, 0, 1)  # Rouge clair pour PLAYER1
	skin_panels[player_cursors[PLAYER2]].self_modulate = Color(0, 2, 0, 1)  # Vert clair pour PLAYER2

### **🎮 Sélectionner un skin** ###
func choose_skin(player, index):
	var skin_texture = game_skins.values()[index]

	# Si le skin est déjà pris, refuser
	if chosen_skins[PLAYER1] == skin_texture or chosen_skins[PLAYER2] == skin_texture:
		return  

	# Appliquer le skin au joueur correspondant
	chosen_skins[player] = skin_texture

	# Sauvegarder le skin (en fonction du joueur qui a choisi)
	if player == PLAYER1:
		Skins.P1 = "res://images/skins/" + skin_texture
	else:
		Skins.P2 = "res://images/skins/" + skin_texture

	audio_selection.play()
	update_panels()

### **❌ Annuler le choix du skin** ###
func remove_skin(player):
	chosen_skins[player] = ""
	update_panels()

### 🎮 **Bouton retour au menu principal** ###
func _on_btn_menu_pressed() -> void:
	SaveManager.Save()
	TransitionScreen.transition("res://maps/menuprincipal.tscn")
