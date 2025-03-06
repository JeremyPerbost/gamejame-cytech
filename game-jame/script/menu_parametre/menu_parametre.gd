extends Control

@onready var btn_menu = $btn_menu
@onready var check_btn_camera = $VBoxContainer/check_btn_camera
@onready var check_btn_musique = $VBoxContainer/check_btn_musique
@onready var check_btn_effects = $VBoxContainer/check_btn_effects
@onready var timer_selection = $timer_selection
@onready var ecraser_sauvegarde_btn=$VBoxContainer/ecraser_sauvegarde_btn
@onready var check_btn_speed_barre=$VBoxContainer/check_btn_speed_barre

var menu_btn = []
var index = 0
var can_navigate = true  # Bloque temporairement la navigation

func _ready() -> void:
	SaveManager.Load()
	menu_btn = [check_btn_camera, check_btn_musique, check_btn_effects,check_btn_speed_barre, ecraser_sauvegarde_btn]
	menu_btn[index].grab_focus()  # Assure que le premier élément est focus
	afficher_valeurs()
	# Appliquer les valeurs stockées
func afficher_valeurs():
	check_btn_camera.button_pressed = Parametres.camera_shaking
	check_btn_musique.button_pressed = Parametres.Musique
	check_btn_effects.button_pressed= Parametres.Effets
	check_btn_speed_barre.button_pressed= Parametres.Speed_bar
func _process(delta: float) -> void:
	if can_navigate:
		navigation()

func navigation():
	if Input.is_action_just_pressed("ui_down") or Input.get_action_strength("ui_p1_down") > 0.5:
		index = (index + 1) % menu_btn.size()
		menu_btn[index].grab_focus()
		_start_selection_timer()

	elif Input.is_action_just_pressed("ui_up") or Input.get_action_strength("ui_p1_up") > 0.5:
		index = (index - 1 + menu_btn.size()) % menu_btn.size()
		menu_btn[index].grab_focus()
		_start_selection_timer()

	if Input.is_action_just_pressed("ui_p1_A"):
		menu_btn[index].button_pressed = not menu_btn[index].button_pressed
		menu_btn[index].emit_signal("pressed")
		_start_selection_timer()

	if Input.is_action_just_pressed("ui_p1_B"):
		btn_menu.emit_signal("pressed")
		_start_selection_timer()

func _on_btn_menu_pressed() -> void:
	SaveManager.Save()
	TransitionScreen.transition("res://maps/menuprincipal.tscn")

func _on_check_btn_camera_pressed() -> void:
	Parametres.camera_shaking = not Parametres.camera_shaking
	print("Camera Shake:", Parametres.camera_shaking)

func _on_check_btn_musique_pressed() -> void:
	Parametres.Musique = check_btn_musique.button_pressed
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), not Parametres.Musique)
	print("Musique activée" if Parametres.Musique else "Musique désactivée")
func _on_check_btn_effects_pressed() -> void:
	Parametres.Effets = not Parametres.Effets
	print("Effets:", Parametres.Effets)
	pass # Replace with function body.
func _on_check_btn_speed_barre_pressed() -> void:
	Parametres.Speed_bar=not Parametres.Speed_bar
	print("Speed bar:", Parametres.Speed_bar)
	pass # Replace with function body.

func _on_ecraser_sauvegarde_btn_pressed() -> void:
	SaveManager.ecraser_sauvegarde()
	afficher_valeurs()
	pass # Replace with function body.
func _start_selection_timer() -> void:
	can_navigate = false  # Bloque la navigation temporairement
	timer_selection.start()  # Démarre le timer

func _on_timer_selection_timeout() -> void:
	can_navigate = true  # Réactive la navigation après le timer
