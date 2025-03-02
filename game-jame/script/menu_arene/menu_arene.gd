extends Control

@onready var survolement = $audio_survolement
@onready var background = $background_menu_arene
@onready var audio_selection = $audio_selection
@onready var panel1 = $GridContainer/Panel_area1
@onready var panel2 = $GridContainer/Panel_area2
@onready var panel3 = $GridContainer/Panel_area3
@onready var panel4 = $GridContainer/Panel_area4
@onready var menu_btn = $btn_menu
@onready var solo_btn = $HBoxContainer/Button_start_solo
@onready var multiplayer_btn = $HBoxContainer/Button_start
@onready var play_btn = $play_btn

var mode_btn = []
var arene_btn = []
var selected_arena = 0  # 0: Stone, 1: Space, 2: Sand
var selected_mode = 0   # 0: Multiplayer, 1: Singleplayer
var selected_row = 0    # 0: Arena Selection, 1: Mode Selection, 2: Play Button

var navigation_timer = 0.0  # Timer for controlling navigation speed
var navigation_delay = 0.2  # Delay between selections (in seconds)

func _ready() -> void:
	MusiqueManager.jouer(load("res://sons/musiques/menu_2_loop.mp3"))
	mode_btn = [multiplayer_btn, solo_btn]
	arene_btn = [panel1, panel2, panel3, panel4]
	menu_btn.button_down.connect(_on_btn_menu_pressed)  # Correction du signal
	_update_selection()

func _process(delta: float) -> void:
	# Update the navigation timer
	navigation_timer += delta
	
	if navigation_timer < navigation_delay:
		return  # Don't process input if the timer hasn't elapsed enough time
	
	if Input.is_action_just_pressed("ui_p1_B"):
		_on_btn_menu_pressed()
	if Input.is_action_just_pressed("ui_down") or Input.get_action_strength("ui_p1_down") > 0.5:
		selected_row = min(selected_row + 1, 3)
		_update_selection()
		navigation_timer = 0.0  # Reset the timer after navigating
	elif Input.is_action_just_pressed("ui_up") or Input.get_action_strength("ui_p1_up") > 0.5:
		selected_row = max(selected_row - 1, 0)
		_update_selection()
		navigation_timer = 0.0  # Reset the timer after navigating
	if selected_row == 1:  # Navigation between arenas
		if Input.is_action_just_pressed("ui_right") or Input.get_action_strength("ui_p1_right") > 0.5:
			selected_arena = ((selected_arena + 1) % 4 + 4) % 4
			_update_selection()
			navigation_timer = 0.0  # Reset the timer after navigating
		elif Input.is_action_just_pressed("ui_left") or Input.get_action_strength("ui_p1_left") > 0.5:
			selected_arena = ((selected_arena - 1) % 4 + 4) % 4
			_update_selection()
			navigation_timer = 0.0  # Reset the timer after navigating
	elif selected_row == 2:  # Navigation between modes
		if Input.is_action_just_pressed("ui_right") or Input.get_action_strength("ui_p1_right") > 0.5:
			selected_mode = ((selected_mode + 1) % 2+2)%2
			_update_selection()
			navigation_timer = 0.0  # Reset the timer after navigating
		elif Input.is_action_just_pressed("ui_left") or Input.get_action_strength("ui_p1_left") > 0.5:
			selected_mode = ((selected_mode -1) % 2+2)%2
			_update_selection()
			navigation_timer = 0.0  # Reset the timer after navigating
	elif selected_row == 3:  # Selection of the play button
		if Input.is_action_just_pressed("ui_p1_A"):
			_on_play_btn_pressed()
func _update_selection() -> void:
	menu_btn.modulate = Color(1, 1, 1, 0.5)
	for i in range(4):
		arene_btn[i].modulate = Color(1, 1, 1, 0.5)  # Grayed out by default
	for i in range(2):
		mode_btn[i].modulate = Color(1, 1, 1, 0.5)
	play_btn.modulate = Color(1, 1, 1, 0.5)
	if selected_row == 0:
		menu_btn.modulate = Color(1, 1, 1, 1)
	if selected_row == 1:
		arene_btn[selected_arena].modulate = Color(1, 1, 1, 1)
	else:
		arene_btn[selected_arena].modulate = Color(0, 1, 0, 0.5)
	if selected_row == 2:
		mode_btn[selected_mode].modulate = Color(1, 1, 1, 1)
	else:
		mode_btn[selected_mode].modulate = Color(0, 1, 0, 0.5)
	if selected_row == 3:
		play_btn.modulate = Color(1, 1, 1, 1)
	survolement.play()  # Plays a sound when changing selection

func _on_btn_menu_pressed() -> void:
	audio_selection.play()
	TransitionScreen.transition("res://maps/menuprincipal.tscn")
func _on_play_btn_pressed() -> void:
	Score.mode_de_jeu = selected_mode
	if selected_mode == 1:
		print("Entering single player mode")
		Skins.P2 = "res://images/skins/ia.png"
	else:
		print("Entering multiplayer mode")
		if Skins.P2=="res://images/skins/ia.png":
			Skins.P2="res://images/skins/P2.png"
	# Associate the selected arena
	match selected_arena:
		0:
			Arene.arene = "res://images/Menus/background/background_combat_pierre.png"
		1:
			Arene.arene = "res://images/Menus/background/background_combat_space.png"
		2:
			Arene.arene = "res://images/Menus/background/background_combat_sand.png"
		3:
			Arene.arene = "res://images/Menus/background/background_combat_dark.png"
	audio_selection.play()
	TransitionScreen.transition("res://maps/toupie.tscn")
