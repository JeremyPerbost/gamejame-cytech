extends Node2D

@onready var anim_death = $death_area/death_collision/death_animation
var reverse_animation = false
var total_frames = 15  # Remplace cette valeur par le nombre de frames dans ton animation.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_death.play("default")  # Commence l'animation normalement
	pass # Replace with function body.
