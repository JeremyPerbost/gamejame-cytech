class_name Menu_Principal
extends Control

@onready var audio_selection = $audio_selection
@onready var audio_survolement = $audio_survolement

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Button as Button
@onready var btn_skin = $MarginContainer/HBoxContainer/VBoxContainer/btn_skin
@onready var btn_collection = $MarginContainer/HBoxContainer/VBoxContainer/btn_collection
@onready var btn_collection2 = $MarginContainer/HBoxContainer/VBoxContainer/btn_collection2
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Button2 as Button

@export var start_level = preload("res://maps/toupie.tscn") as PackedScene
@onready var Title_animation =$MarginContainer/HBoxContainer/VBoxContainer/Title_animation
@onready var toupie_menu = $area_toupie_menu
@onready var toupie_menu_sprite1 = $area_toupie_menu/collision_toupie_menu/sprite_toupie_menu
@onready var toupie_menu2 = $area_toupie_menu2
@onready var toupie_menu_sprite2 = $area_toupie_menu2/collision_toupie_menu2/sprite_toupie_menu2

var velocity_toupie1 = Vector2(900, 900)
var velocity_toupie2 = Vector2(900, 900)
var vitesse_de_rotation_toupie1 = 90.0
var vitesse_de_rotation_toupie2 = 90.0

# Liste des boutons du menu
var menu_buttons = []
var selected_index = 0  # Index du bouton sélectionné
var navigation_delay = 0.2  # Délai pour éviter le spam de navigation
var navigation_timer = 0.0  # Timer de navigation
var dissolve_progress=0
func _ready() -> void:
	# Ajouter les boutons dans la liste pour la navigation
	SaveManager.Load()
	MusiqueManager.jouer(load("res://sons/musiques/menu_1_loop.mp3"))
	menu_buttons = [start_button, btn_skin, btn_collection, btn_collection2, exit_button]

	# Connecter les boutons à leurs fonctions respectives
	start_button.button_down.connect(on_start_pressed)
	btn_skin.button_down.connect(on_skin_pressed)
	btn_collection.button_down.connect(on_collection_pressed)
	btn_collection2.button_down.connect(on_collection2_pressed)
	exit_button.button_down.connect(on_exit_pressed)

	# Focus sur le premier bouton
	update_button_focus()

func _process(delta: float) -> void:
	dissolve_progress = min(dissolve_progress + delta / 3.0, 1.0)
	Title_animation.material.set_shader_parameter("Dissolvevalue", dissolve_progress)
	# Gestion de la navigation avec manette/clavier
	navigation_timer += delta
	handle_menu_navigation()

	# Faire tourner et déplacer les toupies
	toupie_menu_sprite1.rotation += vitesse_de_rotation_toupie1 * delta
	toupie_menu_sprite2.rotation += vitesse_de_rotation_toupie2 * delta

	toupie_menu_sprite1.position += velocity_toupie1 * delta
	toupie_menu_sprite2.position += velocity_toupie2 * delta

	velocity_toupie1 = check_borders(toupie_menu_sprite1, velocity_toupie1)
	velocity_toupie2 = check_borders(toupie_menu_sprite2, velocity_toupie2)

	handle_toupie_collision()

### 🚀 **GESTION NAVIGATION MANETTE / CLAVIER** ###
func handle_menu_navigation():
	if navigation_timer < navigation_delay:
		return  # Évite le spam de navigation

	# Détecter les entrées pour naviguer
	if Input.is_action_just_pressed("ui_down") or Input.get_action_strength("ui_p1_down") > 0.5:
		selected_index = (selected_index + 1) % menu_buttons.size()
		audio_survolement.play()
		update_button_focus()
		navigation_timer = 0.0  # Reset timer

	elif Input.is_action_just_pressed("ui_up") or Input.get_action_strength("ui_p1_up") > 0.5:
		selected_index = (selected_index - 1 + menu_buttons.size()) % menu_buttons.size()
		audio_survolement.play()
		update_button_focus()
		navigation_timer = 0.0  # Reset timer

	# Sélectionner un bouton avec "Entrée" ou "A"
	if Input.is_action_just_pressed("ui_p1_A"):
		menu_buttons[selected_index].emit_signal("button_down")

### **🌟 MISE À JOUR VISUELLE DES BOUTONS** ###
func update_button_focus():
	for i in range(menu_buttons.size()):
		if i == selected_index:
			menu_buttons[i].grab_focus()  # Met le focus visuel sur le bouton sélectionné
		else:
			menu_buttons[i].release_focus()

### 🎮 **FONCTIONS DES BOUTONS** ###
func on_start_pressed():
	audio_selection.play()
	TransitionScreen.transition("res://maps/menus/menu_arene/menu_arene.tscn")

func on_skin_pressed():
	audio_selection.play()
	TransitionScreen.transition("res://maps/menus/menu_skin/menu_skin.tscn")

func on_collection_pressed():
	audio_selection.play()
	TransitionScreen.transition("res://maps/menus/collection_menu/collectionMenu.tscn")

func on_collection2_pressed():
	audio_selection.play()
	TransitionScreen.transition("res://maps/menus/collection_menu/collectionMenu2.tscn")

func on_exit_pressed():
	audio_selection.play()
	await get_tree().create_timer(0.4).timeout
	get_tree().quit()

### 🔥 **GESTION DES COLLISIONS** ###
func check_borders(sprite: Sprite2D, velocity: Vector2) -> Vector2:
	var screen_size = get_viewport_rect().size
	var sprite_size = sprite.texture.get_size() * sprite.scale

	if sprite.position.x - sprite_size.x / 2 <= 0 or sprite.position.x + sprite_size.x / 2 >= screen_size.x:
		velocity.x = -velocity.x
		sprite.position.x = clamp(sprite.position.x, sprite_size.x / 2, screen_size.x - sprite_size.x / 2)

	if sprite.position.y - sprite_size.y / 2 <= 0 or sprite.position.y + sprite_size.y / 2 >= screen_size.y:
		velocity.y = -velocity.y
		sprite.position.y = clamp(sprite.position.y, sprite_size.y / 2, screen_size.y - sprite_size.y / 2)

	return velocity

func handle_toupie_collision():
	var distance = toupie_menu_sprite1.position.distance_to(toupie_menu_sprite2.position)

	var radius1 = toupie_menu_sprite1.texture.get_size().x * toupie_menu_sprite1.scale.x / 2
	var radius2 = toupie_menu_sprite2.texture.get_size().x * toupie_menu_sprite2.scale.x / 2

	if distance <= radius1 + radius2:
		var collision_normal = (toupie_menu_sprite1.position - toupie_menu_sprite2.position).normalized()

		var velocity1_along_normal = velocity_toupie1.dot(collision_normal)
		var velocity2_along_normal = velocity_toupie2.dot(collision_normal)

		var temp = velocity1_along_normal
		velocity1_along_normal = velocity2_along_normal
		velocity2_along_normal = temp

		velocity_toupie1 -= collision_normal * (velocity_toupie1.dot(collision_normal) - velocity1_along_normal)
		velocity_toupie2 -= collision_normal * (velocity_toupie2.dot(collision_normal) - velocity2_along_normal)

		var overlap = radius1 + radius2 - distance
		toupie_menu_sprite1.position += collision_normal * (overlap / 2)
		toupie_menu_sprite2.position -= collision_normal * (overlap / 2)
