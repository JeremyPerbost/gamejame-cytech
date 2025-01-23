extends Node2D

@onready var anim_boost_invincible=$boost_invincible_area/boost_invincible_collision/boost_invincible_animation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_boost_invincible.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
