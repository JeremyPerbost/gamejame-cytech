extends Control

@onready var audio_selection = $audio_selection as AudioStreamPlayer2D
@onready var audio_survolement = $audio_survolement as AudioStreamPlayer2D
@onready var pause_menu = $"."
@onready var btn_continuer = $VBoxContainer/btn_continuer
@onready var btn_quitter = $VBoxContainer/btn_quitter

var pause_selection_index = 0
var is_paused = false
var pause_options = []

func _ready() -> void:
	pause_options = [btn_continuer, btn_quitter]
	_update_pause_selection()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_p1_pause"):
		_toggle_pause()
	if is_paused:
		if Input.is_action_just_pressed("ui_p1_down"):
			pause_selection_index = (pause_selection_index + 1) % len(pause_options)
			_update_pause_selection()
		elif Input.is_action_just_pressed("ui_p1_up"):
			pause_selection_index = (pause_selection_index - 1 + len(pause_options)) % len(pause_options)
			_update_pause_selection()
		elif Input.is_action_just_pressed("ui_p1_A"):
			_select_pause_option()

func _toggle_pause() -> void:
	is_paused = not is_paused
	get_tree().paused = is_paused
	pause_menu.visible = is_paused
	_update_pause_selection()

func _update_pause_selection() -> void:
	for i in range(len(pause_options)):
		pause_options[i].modulate = Color(1, 1, 1)
	pause_options[pause_selection_index].modulate = Color(1, 0, 0)

func _select_pause_option() -> void:
	if pause_selection_index == 0:
		_resume_game()
	elif pause_selection_index == 1:
		_exit_to_menu()

func _resume_game() -> void:
	print("Bouton continuer pressé")
	_toggle_pause()
	audio_selection.play()

func _exit_to_menu() -> void:
	get_tree().paused = false
	TransitionScreen.transition("res://maps/menuprincipal.tscn")

func _on_btn_continuer_pressed() -> void:
	audio_selection.play()
	await get_tree().create_timer(0.3).timeout
	_resume_game()

func _on_btn_quitter_pressed() -> void:
	audio_selection.play()
	_exit_to_menu()

func _on_btn_continuer_mouse_entered() -> void:
	audio_survolement.play()

func _on_btn_quitter_mouse_entered() -> void:
	audio_survolement.play()
