extends Node2D
@onready var anim_transition=$transition_round_area/transition_round_anim
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_transition.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
