extends Control

@onready var anim_speed_boost = $GridContainer/collectable1/boost_animation as AnimatedSprite2D
@onready var anim_invicibility_boost = $GridContainer/collectable2/boost_invincible_animation as AnimatedSprite2D
@onready var anim_trap_boost = $GridContainer/collectable3/trap_boost_animation as AnimatedSprite2D
@onready var anim_black_hole_boost = $GridContainer/collectable4/black_hole_boost_animated as AnimatedSprite2D
@onready var anim_durability_boost = $GridContainer/collectable5/durability_animation as AnimatedSprite2D
@onready var survolement = $survolement
@onready var btn_menu = $btn_menu  # Bouton retour au menu principal
@onready var stat_btn=$stat_btn
var show_stat=false
@onready var dialog_list = [
	$GridContainer/collectable1/speedBoost_description_dialog as Panel,
	$GridContainer/collectable2/invincibility_boost_dialog as Panel,
	$GridContainer/collectable3/trap_boost_dialog as Panel,
	$GridContainer/collectable4/blackHole_boost_dialog as Panel,
	$GridContainer/collectable5/durability_boost_dialog as Panel,
	$GridContainer/collectable6/dash_dialog as Panel,
	$GridContainer/collectable7/teleport_dialog as Panel,
	$GridContainer/collectable8/death_dialog as Panel
]

@onready var collectables = [
	$GridContainer/collectable1,
	$GridContainer/collectable2,
	$GridContainer/collectable3,
	$GridContainer/collectable4,
	$GridContainer/collectable5,
	$GridContainer/collectable6,
	$GridContainer/collectable7,
	$GridContainer/collectable8
]
var collectables_discovered=Collectables.collectables
# Liste qui indique si un collectable a été découvert (1 = découvert, 0 = non découvert)
var hover_index = 0  # L'élément actuellement sélectionné
var navigation_delay = 0.2  # Délai pour éviter le spam
var navigation_timer = 0.0  # Timer pour la navigation
var description_visible = false  # Empêche l'affichage immédiat des descriptions

var columns = 4  # Nombre de colonnes dans la grille
var rows = 2  # Nombre de lignes (calculé automatiquement)

func _ready() -> void:
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

	# Mettre à jour la disponibilité des collectables
	update_collectables_availability()

	# Mettre en surbrillance le premier élément sans afficher la description
	update_selection(false)

func _process(delta: float) -> void:
	navigation_timer += delta
	handle_navigation()
### 🚀 **GESTION NAVIGATION MANETTE / CLAVIER** ###
func handle_navigation():
	if navigation_timer < navigation_delay:
		return  # Empêche le spam de navigation
	var moved = false  # Variable pour savoir si on a changé de sélection
	# Déplacement à droite (ignorer les cases non découvertes)
	if Input.is_action_just_pressed("ui_right") or Input.get_action_strength("ui_p1_right") > 0.5:
		var next_index = hover_index
		while next_index + 1 < collectables.size():  
			next_index += 1
			if collectables_discovered[next_index] == 1:
				hover_index = next_index
				moved = true
				break

	# Déplacement à gauche
	elif Input.is_action_just_pressed("ui_left") or Input.get_action_strength("ui_p1_left") > 0.5:
		var prev_index = hover_index
		while prev_index - 1 >= 0:
			prev_index -= 1
			if collectables_discovered[prev_index] == 1:
				hover_index = prev_index
				moved = true
				break

	# Déplacement vers le haut
	elif Input.is_action_just_pressed("ui_up") or Input.get_action_strength("ui_p1_up") > 0.5:
		var new_index = hover_index
		while new_index - columns >= 0:
			new_index -= columns
			if collectables_discovered[new_index] == 1:
				hover_index = new_index
				moved = true
				break

	# Déplacement vers le bas
	elif Input.is_action_just_pressed("ui_down") or Input.get_action_strength("ui_p1_down") > 0.5:
		var new_index = hover_index
		while new_index + columns < collectables.size():
			new_index += columns
			if collectables_discovered[new_index] == 1:
				hover_index = new_index
				moved = true
				break

	# Si on a changé de case, mettre à jour la sélection avec la description visible
	if moved:
		survolement.play()
		update_selection(false)  # Mettre true pour afficher la description
		navigation_timer = 0.0

	# Sélectionner un collectable (ouvrir/fermer la description)
	if Input.is_action_just_pressed("ui_p1_A"):
		toggle_dialog()

	# Retour au menu
	if Input.is_action_just_pressed("ui_p1_B"):
		on_menu_pressed()
	if Input.is_action_pressed("ui_p1_R2"):
		navigation_timer=0
		if navigation_timer < navigation_delay:
			_on_stat_btn_pressed()
func update_selection(show_description: bool):
	# Réinitialiser toutes les descriptions et enlever les styles précédents
	for i in range(collectables.size()):
		collectables[i].remove_theme_stylebox_override("panel")
		dialog_list[i].hide()  # Cacher toutes les descriptions

		# Rendre indisponible les non-découverts
		if collectables_discovered[i] == 0:
			collectables[i].modulate = Color(0, 0, 0, 1)  # Noir
		else:
			collectables[i].modulate = Color(1, 1, 1, 1)  # Normal

	# Ajouter un contour blanc et afficher la description si découvert
	if collectables_discovered[hover_index] == 1:
		var highlight = StyleBoxFlat.new()
		highlight.border_color = Color(1, 1, 1, 1)  # Bordure blanche
		highlight.border_width_top = 5
		highlight.border_width_bottom = 5
		highlight.border_width_left = 5
		highlight.border_width_right = 5
		collectables[hover_index].add_theme_stylebox_override("panel", highlight)

		# Afficher la description uniquement si demandé
		if show_description:
			dialog_list[hover_index].show()

### **🎮 OUVRIR / FERMER LE DIALOGUE DU COLLECTABLE SÉLECTIONNÉ** ###
func toggle_dialog():
	if collectables_discovered[hover_index] == 0:
		return  # Empêche l'affichage d'une description si l'objet est indisponible

	if dialog_list[hover_index].visible:
		dialog_list[hover_index].hide()
		
	else:
		collectables[hover_index].modulate = Color(1,1,1,1)
		dialog_list[hover_index].show()

### 🛑 **DÉSACTIVER LES COLLECTABLES NON DÉCOUVERTS** ###
func update_collectables_availability():
	for i in range(collectables.size()):
		if collectables_discovered[i] == 0:
			collectables[i].modulate = Color(1, 1, 1, 0.5)  # Noircir l'icône

### 🎮 **BOUTON MENU PRINCIPAL** ###
func on_menu_pressed():
	TransitionScreen.transition("res://maps/menuprincipal.tscn")

func _on_btn_menu_pressed() -> void:
	on_menu_pressed()


func _on_stat_btn_pressed() -> void:
	print("show stat")
	if show_stat==false:
		$Panel_stat_generale.visible=true
		$GridContainer.visible=false
		show_stat=true
	else:
		$Panel_stat_generale.visible=false
		$GridContainer.visible=true
		show_stat=false
	pass # Replace with function body.
