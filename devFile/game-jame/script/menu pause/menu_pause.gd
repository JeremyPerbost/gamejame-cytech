extends Control
@onready var audio_selection = $audio_selection as AudioStreamPlayer2D
@onready var audio_survolement = $audio_survolement as AudioStreamPlayer2D
@onready var pause_menu = $"."

func _ready() -> void:
	pass # Replace with function body.

func resume():
	print("bouton continuer presser")
	get_tree().paused = false
	pause_menu.hide()
func _process(delta: float) -> void:
	pass
func _on_btn_continuer_pressed() -> void:
	audio_selection.play()
	await get_tree().create_timer(0.3).timeout
	resume()
	pass # Replace with function body.
func _on_btn_quitter_pressed() -> void:
	audio_selection.play()
	get_tree().paused = false
	TransitionScreen.transition("res://maps/menuprincipal.tscn")

func _on_btn_continuer_mouse_entered() -> void:
	audio_survolement.play()
func _on_btn_quitter_mouse_entered() -> void:
	audio_survolement.play()
