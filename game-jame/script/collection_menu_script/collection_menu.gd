extends Control

@onready var anim_speed_boost = $GridContainer/collectable1/boost_animation as AnimatedSprite2D
@onready var anim_invicibility_boost = $GridContainer/collectable2/boost_invincible_animation as AnimatedSprite2D
@onready var anim_trap_boost = $GridContainer/collectable3/trap_boost_animation as AnimatedSprite2D
@onready var anim_black_hole_boost = $GridContainer/collectable4/black_hole_boost_animated as AnimatedSprite2D
@onready var anim_durability_boost = $GridContainer/collectable5/durability_animation as AnimatedSprite2D
@onready var survolement = $survolement
@onready var btn_menu = $btn_menu  # Bouton retour au menu principal

@onready var dialog_list = [
	$GridContainer/collectable1/speedBoost_description_dialog as Panel,
	$GridContainer/collectable2/invincibility_boost_dialog as Panel,
	$GridContainer/collectable3/trap_boost_dialog as Panel,
	$GridContainer/collectable4/blackHole_boost_dialog as Panel,
	$GridContainer/collectable5/durability_boost_dialog as Panel,
	$GridContainer/collectable6/dash_dialog as Panel,
	$GridContainer/collectable7/teleport_dialog as Panel
]

@onready var collectables = [
	$GridContainer/collectable1,
	$GridContainer/collectable2,
	$GridContainer/collectable3,
	$GridContainer/collectable4,
	$GridContainer/collectable5,
	$GridContainer/collectable6,
	$GridContainer/collectable7
]

var hover_index = 0  # L'élément actuellement sélectionné
var navigation_delay = 0.2  # Délai pour éviter le spam
var navigation_timer = 0.0  # Timer pour la navigation
var description_visible = false  # Empêche l'affichage immédiat des descriptions

var columns = 4  # Nombre de colonnes dans la grille
var rows = 2  # Nombre de lignes (calculé automatiquement)

func _ready() -> void:
	# Lancer les animations des collectables
	MusiqueManager.jouer(load("res://sons/musiques/menu_2_loop.mp3"))
	anim_speed_boost.play()
	anim_invicibility_boost.play()
	anim_trap_boost.play()
	anim_black_hole_boost.play()
	anim_durability_boost.play()
	
	# Cacher tous les dialogues au départ
	for dialog_item in dialog_list:
		if dialog_item:
			dialog_item.hide()

	# Définir le nombre de lignes de la grille en fonction du nombre total d'items
	rows = ceil(float(collectables.size()) / columns)

	# Mettre en surbrillance le premier élément sans afficher la description
	update_selection(false)

func _process(delta: float) -> void:
	navigation_timer += delta
	handle_navigation()

### 🚀 **GESTION NAVIGATION MANETTE / CLAVIER** ###
func handle_navigation():
	if navigation_timer < navigation_delay:
		return  # Empêche le spam de navigation

	# Déplacement à droite
	if Input.is_action_just_pressed("ui_right") or Input.get_action_strength("move_right") > 0.5:
		if (hover_index + 1) % columns != 0 and hover_index + 1 < collectables.size():
			hover_index += 1
			survolement.play()
			update_selection(false)
			navigation_timer = 0.0  

	# Déplacement à gauche
	elif Input.is_action_just_pressed("ui_left") or Input.get_action_strength("move_left") > 0.5:
		if hover_index % columns != 0:
			hover_index -= 1
			survolement.play()
			update_selection(false)
			navigation_timer = 0.0  

	# Déplacement vers le haut (sauter une ligne)
	elif Input.is_action_just_pressed("ui_up") or Input.get_action_strength("move_up") > 0.5:
		if hover_index - columns >= 0:
			hover_index -= columns
			survolement.play()
			update_selection(false)
			navigation_timer = 0.0

	# Déplacement vers le bas (descendre une ligne)
	elif Input.is_action_just_pressed("ui_down") or Input.get_action_strength("move_down") > 0.5:
		if hover_index + columns < collectables.size():
			hover_index += columns
			survolement.play()
			update_selection(false)
			navigation_timer = 0.0

	# Sélectionner un collectable (ouvrir la description)
	if Input.is_action_just_pressed("ui_p1_A"):
		toggle_dialog()

	# Retour au menu avec "B" sur la manette ou "Échap"
	if Input.is_action_just_pressed("ui_p1_B"):
		on_menu_pressed()

func update_selection(show_description: bool):
	# Réinitialiser toutes les couleurs et cacher les dialogues
	for i in range(collectables.size()):
		collectables[i].modulate = Color(1, 1, 1, 1)  # Normal
		dialog_list[i].hide()  # Masquer tous les dialogues

	# Appliquer une mise en avant sur l'élément sélectionné
	collectables[hover_index].modulate = Color(0.42, 0.42, 0.42, 1)  # Jaune clair pour mettre en avant

	# Afficher la description seulement si demandé
	if show_description:
		dialog_list[hover_index].show()

### **🎮 OUVRIR / FERMER LE DIALOGUE DU COLLECTABLE SÉLECTIONNÉ** ###
func toggle_dialog():
	if dialog_list[hover_index].visible:
		dialog_list[hover_index].hide()
		collectables[hover_index].modulate = Color(0.42, 0.42, 0.42, 1)
	else:
		collectables[hover_index].modulate = Color(1,1,1,1)
		dialog_list[hover_index].show()

### 🎮 **BOUTON MENU PRINCIPAL** ###
func on_menu_pressed():
	TransitionScreen.transition("res://maps/menuprincipal.tscn")

func _on_btn_menu_pressed() -> void:
	on_menu_pressed()
