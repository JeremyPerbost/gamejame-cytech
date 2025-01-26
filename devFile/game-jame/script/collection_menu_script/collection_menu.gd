extends Control

@onready var anim_speed_boost = $GridContainer/collectable1/boost_animation as AnimatedSprite2D
@onready var anim_invicibility_boost = $GridContainer/collectable2/boost_invincible_animation as AnimatedSprite2D
@onready var anim_trap_boost = $GridContainer/collectable3/trap_boost_animation as AnimatedSprite2D
@onready var anim_black_hole_boost = $GridContainer/collectable4/black_hole_boost_animated as AnimatedSprite2D
@onready var anim_durability_boost = $GridContainer/collectable5/durability_animation as AnimatedSprite2D

@onready var dialog_list = [
	$GridContainer/collectable1/speedBoost_description_dialog as Panel,
	$GridContainer/collectable2/invincibility_boost_dialog as Panel,
	$GridContainer/collectable3/trap_boost_dialog as Panel,
	$GridContainer/collectable4/blackHole_boost_dialog as Panel,
	$GridContainer/collectable5/durability_boost_dialog as Panel,
	$GridContainer/collectable6/dash_dialog as Panel,
	$GridContainer/collectable7/teleport_dialog as Panel
]

@onready var collectables = [
	$GridContainer/collectable1,
	$GridContainer/collectable2,
	$GridContainer/collectable3,
	$GridContainer/collectable4,
	$GridContainer/collectable5,
	$GridContainer/collectable6,
	$GridContainer/collectable7
]

var hover_index = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_speed_boost.play()
	anim_invicibility_boost.play()
	anim_trap_boost.play()
	anim_black_hole_boost.play()
	anim_durability_boost.play()
	
	for dialog_item in dialog_list:
		if dialog_item == null:
			print("Node not found in dialog_list!")
		else:
			dialog_item.hide()

# Track mouse position every frame
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var found_hover = false

	for i in range(collectables.size()):
		if collectables[i].get_global_rect().has_point(mouse_pos):
			if hover_index != i:
				# Show the dialog for the hovered collectable
				if hover_index >= 0 and hover_index < dialog_list.size():
					dialog_list[hover_index].hide()
				hover_index = i
				dialog_list[i].show()
			found_hover = true
			break
	
	if not found_hover and hover_index != -1:
		# Hide the last dialog when no collectable is hovered
		dialog_list[hover_index].hide()
		hover_index = -1
