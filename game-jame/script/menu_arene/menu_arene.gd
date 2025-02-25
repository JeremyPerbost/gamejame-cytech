extends Control

@onready var survolement = $audio_survolement
@onready var background = $background_menu_arene
@onready var audio_selection = $audio_selection
@onready var panel1 = $GridContainer/Panel_area1
@onready var panel2 = $GridContainer/Panel_area2
@onready var panel3 = $GridContainer/Panel_area3
@onready var menu_button = $btn_menu
@onready var start_button = $HBoxContainer/Button_start_solo
@onready var multiplayer_button = $HBoxContainer/Button_start

var selected_panel_index = 0
var selected_mode_index = 0
var selected_menu_index = 0
var panels = []
var mode_selection = false  # False = Arena selection, True = Mode selection
var modes = []
var menu_buttons = []

func _ready() -> void:
	MusiqueManager.jouer(load("res://sons/musiques/menu_2_loop.mp3"))
	panels = [panel1, panel2, panel3]
	modes = [start_button, multiplayer_button]
	menu_buttons = [menu_button]
	_update_selection()

func _process(delta: float) -> void:
	if not mode_selection:
		if Input.is_action_just_pressed("ui_p1_right"):
			_change_selection(1)
		elif Input.is_action_just_pressed("ui_p1_left"):
			_change_selection(-1)
		elif Input.is_action_just_pressed("ui_p1_down"):
			_switch_to_mode_selection()
	elif mode_selection:
		if Input.is_action_just_pressed("ui_p1_up"):
			_switch_to_arena_selection()
		elif Input.is_action_just_pressed("ui_p1_right"):
			_change_mode_selection(1)
		elif Input.is_action_just_pressed("ui_p1_left"):
			_change_mode_selection(-1)
		elif Input.is_action_just_pressed("ui_p1_A"):
			_select_mode()
	if Input.is_action_just_pressed("ui_p1_B"):
		_on_btn_menu_pressed()

func _change_selection(direction: int) -> void:
	selected_panel_index = (selected_panel_index + direction + panels.size()) % panels.size()
	_update_selection()

func _switch_to_mode_selection() -> void:
	mode_selection = true
	selected_mode_index = 0
	_update_mode_selection()

func _switch_to_arena_selection() -> void:
	mode_selection = false
	_update_selection()

func _change_mode_selection(direction: int) -> void:
	selected_mode_index = (selected_mode_index + direction + modes.size()) % modes.size()
	_update_mode_selection()

func _update_selection() -> void:
	for panel in panels:
		panel.modulate = Color(1, 1, 1)
	panels[selected_panel_index].modulate = Color(1, 0, 0)
	_on_panel_hovered(panels[selected_panel_index])

func _update_mode_selection() -> void:
	for mode in modes:
		mode.set("modulate", Color(1, 1, 1))
	modes[selected_mode_index].set("modulate", Color(1, 0, 0))

func _on_panel_hovered(panel) -> void:
	if panel == panel1:
		background.texture = load("res://images/Menus/background/background_combat_pierre.png")
	elif panel == panel2:
		background.texture = load("res://images/Menus/background/background_combat_space.png")
	elif panel == panel3:
		background.texture = load("res://images/Menus/background/background_combat_sand.png")
	survolement.play()

func _select_mode() -> void:
	if selected_mode_index == 0:
		_on_button_start_solo_pressed()
	elif selected_mode_index == 1:
		_on_button_start_pressed()

func _on_btn_menu_pressed() -> void:
	TransitionScreen.transition("res://maps/menuprincipal.tscn")

func _on_button_start_solo_pressed() -> void:
	Score.mode_de_jeu=1
	print("Entrer dans le mode solo")
	Skins.P2="res://images/skins/ia.png"
	TransitionScreen.transition("res://maps/toupie.tscn")
func _on_button_start_pressed() -> void:
	Score.mode_de_jeu=0
	print("Entrer dans le mode multijoueur")
	TransitionScreen.transition("res://maps/toupie.tscn")
	pass # Replace with function body.
