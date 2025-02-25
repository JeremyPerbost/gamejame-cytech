extends Node2D

@onready var label_time = $spr_time/label_time
var time_left: float = 60.0  # Durée du timer en secondes

# Permet de définir une durée personnalisée en minutes
func set_timer(minutes: float) -> void:
	time_left = minutes * 60
	update_label()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time_left > 0:
		time_left -= delta
		if time_left < 0:
			time_left = 0
		update_label()

func update_label() -> void:
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	label_time.text =str(minutes) + ":" + str(seconds)
