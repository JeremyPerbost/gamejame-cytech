extends Node2D

@onready var anim_boost_trounoir=$boost_trounoir_area/boost_trounoir_collision/boost_trounoir_animation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_boost_trounoir.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
