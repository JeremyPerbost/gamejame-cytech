class_name Menu_Principal
extends Control
@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Button as Button #charge les assets
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Button2 as Button
@export var start_level = preload("res://maps/toupie.tscn") as PackedScene


func _ready() -> void:
	start_button.button_down.connect(on_start_pressed	)#actionne quand le button est pressioné
	exit_button.button_down.connect(on_exit_pressed	)

func on_start_pressed():
	get_tree().change_scene_to_packed(start_level) #changement de scene
	
func on_exit_pressed():
	get_tree().quit()
