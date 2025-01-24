extends Control

@onready var label_player1 = $label_player1

var players = ["player1", "player2"]

var current_index = 0
@onready var skin8=$GridContainer/skin8
@onready var skin7=$GridContainer/skin7
@onready var skin6=$GridContainer/skin6
@onready var skin5=$GridContainer/skin5
@onready var skin4=$GridContainer/skin4
@onready var skin3=$GridContainer/skin3
@onready var skin2=$GridContainer/skin2
@onready var skin1=$GridContainer/skin1

func _ready() -> void:
	update_labels()
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		current_index = (current_index + 1) % players.size()
		update_labels()

	if Input.is_action_just_pressed("ui_left"):
		current_index = (current_index - 1 + players.size()) % players.size()
		update_labels()

func update_labels() -> void:
	# Mettez à jour les labels comme vous le souhaitez.
	label_player1.text = players[current_index]


func _on_skin_3_mouse_entered() -> void:
	skin3.self_modulate=Color.WHITE
	pass # Replace with function body.


func _on_skin_3_mouse_exited() -> void:
	skin3.self_modulate=Color.BLACK
	pass # Replace with function body.
func _on_btn_menu_pressed() -> void:
	TransitionScreen.transition("res://maps/menuprincipal.tscn")
	pass # Replace with function body.
func _on_skin_1_mouse_entered() -> void:
	skin1.self_modulate=Color.WHITE
	pass # Replace with function body.
func _on_skin_1_mouse_exited() -> void:
	skin1.self_modulate=Color.BLACK
	pass # Replace with function body.
func _on_skin_2_mouse_entered() -> void:
	skin2.self_modulate=Color.WHITE
	pass # Replace with function body.
func _on_skin_2_mouse_exited() -> void:
	skin2.self_modulate=Color.BLACK
	pass # Replace with function body.
func _on_skin_4_mouse_entered() -> void:
	skin4.self_modulate=Color.WHITE
	pass # Replace with function body.
func _on_skin_4_mouse_exited() -> void:
	skin4.self_modulate=Color.BLACK
	pass # Replace with function body.
func _on_skin_5_mouse_entered() -> void:
	skin5.self_modulate=Color.WHITE
	pass # Replace with function body.
func _on_skin_5_mouse_exited() -> void:
	skin5.self_modulate=Color.BLACK
	pass # Replace with function body.
func _on_skin_6_mouse_entered() -> void:
	skin6.self_modulate=Color.WHITE
	pass # Replace with function body.
func _on_skin_6_mouse_exited() -> void:
	skin6.self_modulate=Color.BLACK
	pass # Replace with function body.
func _on_skin_7_mouse_entered() -> void:
	skin7.self_modulate=Color.WHITE
	pass # Replace with function body.
func _on_skin_7_mouse_exited() -> void:
	skin7.self_modulate=Color.BLACK
	pass # Replace with function body.
func _on_skin_8_mouse_entered() -> void:
	skin8.self_modulate=Color.WHITE
	pass # Replace with function body.
func _on_skin_8_mouse_exited() -> void:
	skin8.self_modulate=Color.BLACK
	pass # Replace with function body.
func _on_skin_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print("P1 : blue CHOISIS")
			Skins.P1="res://images/skins/P2.png"
			
	pass # Replace with function body.
func _on_skin_1_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print("P1 : red CHOISIS")
			Skins.P1="res://images/skins/P1.png"
	pass # Replace with function body.
func _on_skin_3_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print("P1 : white CHOISIS")
			Skins.P1="res://images/skins/skin1.png"
	pass # Replace with function body.
func _on_skin_4_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print("P1 : purple CHOISIS")
			Skins.P1="res://images/skins/purple.png"
	pass # Replace with function body.
func _on_skin_5_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print("P1 : duo CHOISIS")
			Skins.P1="res://images/skins/duo.png"
	pass # Replace with function body.
func _on_skin_6_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print("P1 : military CHOISIS")
			Skins.P1="res://images/skins/military.png"
	pass # Replace with function body.
func _on_skin_7_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print("P1 : human CHOISIS")
			Skins.P1="res://images/skins/human.png"
	pass # Replace with function body.
func _on_skin_8_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print("P1 : deep CHOISIS")
			Skins.P1="res://images/skins/blue2.png"
	pass # Replace with function body.
