extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_p1_B"):
		_on_btn_menu_pressed()
	pass


func _on_btn_menu_pressed() -> void:
	TransitionScreen.transition("res://maps/menus/menu_arene/menu_arene.tscn")
	pass # Replace with function body.
