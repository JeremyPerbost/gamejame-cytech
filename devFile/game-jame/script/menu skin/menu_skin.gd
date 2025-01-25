extends Control

const PLAYER1 = 0
const PLAYER2 = 1

var action_stack = []

enum SkinAvailables { RED, BLUE, WHITE, PURPLE, DUO, MILITARY, HUMAN, DEEP }


var game_skins = {
	SkinAvailables.RED: "P1.png",
	SkinAvailables.BLUE: "P2.png",
	SkinAvailables.WHITE: "skin1.png",
	SkinAvailables.PURPLE: "purple.png",
	SkinAvailables.DUO: "duo.png",
	SkinAvailables.MILITARY: "military.png",
	SkinAvailables.HUMAN: "human.png",
	SkinAvailables.DEEP: "blue2.png"
}

var chosen_skins = {
	PLAYER1: "",
	PLAYER2: ""
}
@onready var audio_selection=$audio_selection
@onready var audio_survolement=$audio_survolement


@onready var skin_panels = {
	game_skins[SkinAvailables.RED]: $GridContainer/skin1 as Panel,
	game_skins[SkinAvailables.BLUE]: $GridContainer/skin2 as Panel,
	game_skins[SkinAvailables.WHITE]: $GridContainer/skin3 as Panel,
	game_skins[SkinAvailables.PURPLE]: $GridContainer/skin4 as Panel,
	game_skins[SkinAvailables.DUO]: $GridContainer/skin5 as Panel,
	game_skins[SkinAvailables.MILITARY]: $GridContainer/skin6 as Panel,
	game_skins[SkinAvailables.HUMAN]: $GridContainer/skin7 as Panel,
	game_skins[SkinAvailables.DEEP]: $GridContainer/skin8 as Panel
}

func _ready() -> void:
	update_panels()

func _process(delta: float) -> void:
	pass

func update_panels() -> void:
	for skin_texture in game_skins.values():
		var panel = skin_panels.get(skin_texture)
		if panel:
			if chosen_skins[PLAYER1] == skin_texture:
				panel.self_modulate = Color.RED
				Skins.P1="res://images/skins/"+skin_texture
				audio_selection.play()
			elif chosen_skins[PLAYER2] == skin_texture:
				panel.self_modulate = Color.GREEN
				Skins.P2="res://images/skins/"+skin_texture
				audio_selection.play()
			else:
				panel.self_modulate = Color.BLACK

func is_skin_picked_up(skin_texture: String) -> bool:
	return chosen_skins[PLAYER1] != skin_texture and chosen_skins[PLAYER2] != skin_texture

func choose_skin(skin_texture: String) -> void:
	if is_skin_picked_up(skin_texture):
		if action_stack.is_empty():
			chosen_skins[PLAYER1] = skin_texture
			action_stack.append(PLAYER1)
		else:
			chosen_skins[PLAYER2] = skin_texture
			action_stack.pop_back()
		update_panels()

func _on_skin_mouse_exited(skin_texture: String) -> void:
	update_panels()  # Reset the panel colors based on current state


# Fonctions d'entree et sortie du cursor
func mouse_in(skin_texture: String) -> void:
	if is_skin_picked_up(skin_texture):
		skin_panels[skin_texture].self_modulate = Color.LIGHT_GRAY
func mouse_out(skin_texture: String):
	if is_skin_picked_up(skin_texture):
		skin_panels[skin_texture].self_modulate = Color.BLACK

# GUI Input Handling for Each Panel
func _on_skin_gui_input(event: InputEvent, skin_texture: String) -> void:
	if event is InputEventMouseButton and event.pressed:
		choose_skin(skin_texture)

# Example Binding for Each Panel
func _on_skin_1_gui_input(event: InputEvent) -> void:
	_on_skin_gui_input(event, game_skins[SkinAvailables.RED])

func _on_skin_2_gui_input(event: InputEvent) -> void:
	_on_skin_gui_input(event, game_skins[SkinAvailables.BLUE])

func _on_skin_3_gui_input(event: InputEvent) -> void:
	_on_skin_gui_input(event, game_skins[SkinAvailables.WHITE])

func _on_skin_4_gui_input(event: InputEvent) -> void:
	_on_skin_gui_input(event, game_skins[SkinAvailables.PURPLE])

func _on_skin_5_gui_input(event: InputEvent) -> void:
	_on_skin_gui_input(event, game_skins[SkinAvailables.DUO])

func _on_skin_6_gui_input(event: InputEvent) -> void:
	_on_skin_gui_input(event, game_skins[SkinAvailables.MILITARY])

func _on_skin_7_gui_input(event: InputEvent) -> void:
	_on_skin_gui_input(event, game_skins[SkinAvailables.HUMAN])

func _on_skin_8_gui_input(event: InputEvent) -> void:
	_on_skin_gui_input(event, game_skins[SkinAvailables.DEEP])
	

func _on_btn_menu_pressed() -> void:
	TransitionScreen.transition("res://maps/menuprincipal.tscn")

#Fonctions rélationés à la position du cursor
func _on_skin_1_mouse_entered() -> void:
	audio_survolement.play()
	mouse_in(game_skins[SkinAvailables.RED])
func _on_skin_1_mouse_exited() -> void:
	mouse_out(game_skins[SkinAvailables.RED])

func _on_skin_2_mouse_entered() -> void:
	audio_survolement.play()
	mouse_in(game_skins[SkinAvailables.BLUE])
func _on_skin_2_mouse_exited() -> void:
	mouse_out(game_skins[SkinAvailables.BLUE])
	
func _on_skin_3_mouse_entered() -> void:
	audio_survolement.play()
	mouse_in(game_skins[SkinAvailables.WHITE])
func _on_skin_3_mouse_exited() -> void:
	mouse_out(game_skins[SkinAvailables.WHITE])

func _on_skin_4_mouse_entered() -> void:
	audio_survolement.play()
	mouse_in(game_skins[SkinAvailables.PURPLE])
func _on_skin_4_mouse_exited() -> void:
	mouse_out(game_skins[SkinAvailables.PURPLE])

func _on_skin_5_mouse_entered() -> void:
	audio_survolement.play()
	mouse_in(game_skins[SkinAvailables.DUO])
func _on_skin_5_mouse_exited() -> void:
	mouse_out(game_skins[SkinAvailables.DUO])

func _on_skin_6_mouse_entered() -> void:
	audio_survolement.play()
	mouse_in(game_skins[SkinAvailables.MILITARY])
func _on_skin_6_mouse_exited() -> void:
	mouse_out(game_skins[SkinAvailables.MILITARY])

func _on_skin_7_mouse_entered() -> void:
	audio_survolement.play()
	mouse_in(game_skins[SkinAvailables.HUMAN])
func _on_skin_7_mouse_exited() -> void:
	mouse_out(game_skins[SkinAvailables.HUMAN])

func _on_skin_8_mouse_entered() -> void:
	audio_survolement.play()
	mouse_in(game_skins[SkinAvailables.DEEP])
	
func _on_skin_8_mouse_exited() -> void:
	mouse_out(game_skins[SkinAvailables.DEEP])
