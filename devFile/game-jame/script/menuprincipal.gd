class_name Menu_Principal
extends Control
@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Button as Button #charge les assets
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Button2 as Button
@export var start_level = preload("res://maps/toupie.tscn") as PackedScene


func _ready() -> void:
	start_button.button_down.connect(on_start_pressed)#actionne quand le button est pressioné
	exit_button.button_down.connect(on_exit_pressed)
	

func on_start_pressed():
	TransitionScreen.transition("res://maps/toupie.tscn")
	
func on_exit_pressed():
	get_tree().quit()


func _on_btn_skin_pressed() -> void:
	TransitionScreen.transition("res://maps/menus/menu_skin/menu_skin.tscn")
	pass # Replace with function body.
