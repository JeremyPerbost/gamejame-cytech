extends RigidBody2D

# Vitesse de la toupie
var speed = 200

func _ready():
	# Désactiver la gravité pour cette toupie
	gravity_scale = 0
	linear_damp = 5  # Pour ralentir progressivement le mouvement quand aucune touche n'est appuyée

func _integrate_forces(_state):
	var impulse = Vector2.ZERO
	
	# Vérifie les touches fléchées pressées
	if Input.is_action_pressed("ui_up"):
		impulse.y -= 1
	if Input.is_action_pressed("ui_down"):
		impulse.y += 1
	if Input.is_action_pressed("ui_left"):
		impulse.x -= 1
	if Input.is_action_pressed("ui_right"):
		impulse.x += 1
		print("droite")

	# Si une touche est pressée, applique une impulsion
	if impulse.length() > 0:
		impulse = impulse.normalized() * speed
		apply_central_impulse(impulse)
