extends Control

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
	resume()
	pass # Replace with function body.


func _on_btn_quitter_pressed() -> void:
	TransitionScreen.transition("res://maps/menuprincipal.tscn")
	pass # Replace with function body.
