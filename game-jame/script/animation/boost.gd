extends Node2D
@onready var boost=$boost_area/boost_collision/boost_animation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boost.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
