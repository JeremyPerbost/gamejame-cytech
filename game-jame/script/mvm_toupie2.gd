extends Area2D
#indice player
var player_index = 1
# Vitesse de mouvement
var speed_init = 80
var speed = speed_init
# Force d'attraction vers le centre
var attraction_strength = 400
# Vélocité de la toupie
var velocity = Vector2.ZERO
var variable_de_choc = 80
var attraction_factor = 1
var direction = Vector2.ZERO
var rotation_autour_arene=Vector2.ZERO #vecteur de force de rotation autour du centre de l'arene du a la rotation de la pointe
var sens_rotations=1 #sens des aiguilles d'une montre
# Référence au centre
var center
var temps
var distance_to_center
var min_distance = 50
@onready var duree_effet_trounoir = $effet_trounoir_toupie2 
@onready var duree_effet_invincible = $effet_invincible_toupie2
@onready var memoire_attraction_strength
@onready var spr_choc_animation=$spr_choc_animation

var effet_trou_noir = false #BOOST
var effet_invincible = false #BOOST
func _ready():
	spr_choc_animation.play("default")
	center = get_parent().get_node("../centre")
	temps = get_node("/root/Toupie")
	if center == null:
		print(" TP2 : Le nœud 'centre' n'a pas été trouvé dans la scène.")
	if temps == null:
		print("TP2 : Le nœud 'temps' n'a pas été trouvé dans la scène.")

func _process(delta):
	direction = Vector2.ZERO
	var toupie1 = get_node("../Area_toupie1")
	if toupie1 == null:
		print("TP2 : toupie1 non trouvée")
	#-------GESTION DES BONUS--------
	#EFFET TROU NOIR
	if effet_trou_noir==true:
		attraction_strength=attraction_strength+10
	#EFFET INVINCIBLE dans la fonction collision
	#-------------------------------
	# Gestion du ralentissement exponentiel
	if speed > 0:
		speed = speed-0.01
	else:
		speed = 0
		winner_round.emit("Player1")

	rotation += (speed /3) * delta
	# Détection des touches pour le déplacement du joueur
	if Input.is_joy_button_pressed(player_index,11) or Input.is_action_pressed("ui_Z"):
		direction.y -= 1
	if Input.is_joy_button_pressed(player_index,12) or Input.is_action_pressed("ui_S"):
		direction.y += 1
	if Input.is_joy_button_pressed(player_index,13) or Input.is_action_pressed("ui_Q"):
		direction.x -= 1
	if Input.is_joy_button_pressed(player_index,14) or Input.is_action_pressed("ui_D"):
		direction.x += 1

	# Normaliser la direction si elle n'est pas nulle
	if direction != Vector2.ZERO:
		direction = direction.normalized()

	# Calculer la distance entre la toupie et le centre
	distance_to_center = (center.position - self.position).length()

	# Si la toupie est trop proche du centre, l'attraction devient très faible pour la laisser s'échapper
	min_distance = 50  # Ajuste ce seuil en fonction de la taille de ta scène ou toupie
	attraction_factor = 1
	if distance_to_center < min_distance:
		attraction_factor = 0  # Réduit l'attraction progressivement

	# Calculer la force d'attraction proportionnelle à la distance, avec une limite et un facteur d'attraction dynamique
	var attraction_strength_dynamic = clamp(attraction_strength * (1 / max(distance_to_center, 1)), 0, 500) * attraction_factor

	# Calculer le vecteur d'attraction vers le centre
	var attraction_vector = (center.position - self.position).normalized() * attraction_strength_dynamic

	# Calculer la force centrifuge qui est opposée à l'attraction, et proportionnelle à la vitesse de la toupie
	var speed_magnitude = velocity.length()
	var centrifugal_strength = clamp(speed_magnitude * 0.1, 0, 300)  # Ajuste le coefficient 0.1 et la limite selon les besoins
	var centrifugal_vector = (self.position - center.position).normalized().rotated(PI / 2) * centrifugal_strength

	# Calculer la force appliquée par le joueur
	var player_force = direction * speed * 10

	# Combiner les forces (attraction, direction joueur, centrifuge)
	var combined_force = player_force + attraction_vector * 40 + centrifugal_vector
		# --------------TOURNER AUTOUR DU CENTRE--------------------------------------------
	# Calcul de la force tangentielle autour de l'arène
	var tangent = (self.position - center.position).normalized().rotated(sens_rotations * PI/2)
	rotation_autour_arene = tangent * 100
	combined_force += rotation_autour_arene
	if distance_to_center > 265:
		# Forcer la toupie à rester dans l'arène
		var correction_vector = (self.position - center.position).normalized() * (distance_to_center - 265)
		self.position -= correction_vector  # Ramener la toupie dans l'arène

		# Inverser la vélocité pour simuler un rebond contre le bord
		velocity = (self.position - center.position).normalized() * -velocity.length() * 0.35
	#-------Partie de code a optimiser : ----------
	var direction_anim = (toupie1.global_position - global_position).normalized()
	spr_choc_animation.rotation= -rotation-80+direction_anim.angle()#correction de la rotation de l'animation
	#----------------------------------------------
	velocity += combined_force * delta
	self.position += velocity * delta

	
	
func collision(area):
	var toupie1 = get_node("../Area_toupie1")
	if toupie1 == null:
		print("TP2 : toupie1 non trouvée")
	else:
		# Calcul de la normale de la collision
		var collision_normal = (self.position - area.position).normalized()
		# Projeter les vitesses sur la normale de collision
		var toupie1_velocity_along_normal = collision_normal.dot(toupie1.velocity)
		var toupie2_velocity_along_normal = collision_normal.dot(velocity)

		# Calcul de la différence de vitesse relative
		var relative_velocity = toupie2_velocity_along_normal - toupie1_velocity_along_normal

		# Ajuster les vitesses des deux toupies en fonction de la collision
		var impulse = relative_velocity * collision_normal * 0.5

		# Réduire légèrement la vitesse pour simuler une perte d'énergie
		toupie1.velocity += impulse * 1.5  # La toupie 1 gagne une part de l'impulsion ancienne valeur = 0.9
		velocity -= impulse * 1  # La toupie 2 perd une part de l'impulsionancienne valeur = 0.5
		velocity *= 0.9  # Réduction de la vitesse de toupie2 pour simuler la perte d'énergie 
		var separation_distance = collision_normal * 10  # Ajuste cette valeur pour le niveau de séparation souhaité
		self.position += separation_distance
		toupie1.position -= separation_distance
		if ((toupie1.velocity.length()/50)>=(velocity.length()/50) and effet_invincible==false):
			speed=speed-(float(toupie1.velocity.length())/variable_de_choc)
		#--------------GESTION DE L'ANIMATION DE CHOC----------------
		spr_choc_animation.visible = true#on montre l'animation
		$animation_choc_toupie2.start()#demarrer le timer pour montrer l'animation
		print("animation montrer")
		
func _on_area_entered(area: Area2D) -> void:
	if area.collision_layer==1:
		collision(area)
	if area.collision_layer==2:
		print("TP2: Booster")
		speed=speed+15
		area.queue_free()
	if area.collision_layer==4:
		print("TP2: durability")
		variable_de_choc=variable_de_choc+15
		area.queue_free()
	if area.collision_layer==8:
		print("TP2: trou noire")
		$spr_trou_noir.visible=true
		effet_trou_noir=true
		memoire_attraction_strength=attraction_strength
		duree_effet_trounoir.start()
		area.queue_free()
	if area.collision_layer==16:
		print("TP2: Invincible")
		$spr_invincible.visible=true
		effet_invincible=true
		duree_effet_invincible.start()
		area.queue_free()
	pass


func _on_effet_trounoir_toupie_2_timeout() -> void:
	if effet_trou_noir==true:
		effet_trou_noir=false#Desactiver l'effet du trou noir
		$spr_trou_noir.visible=false
		print("TP2: FIN DU TROU NOIR")
		attraction_strength=memoire_attraction_strength
	pass # Replace with function body.


func _on_effet_invincible_toupie_2_timeout() -> void:
	if effet_invincible==true:
		$spr_invincible.visible=false
		effet_invincible=false#Desactiver l'effet invincible
		print("TP2: FIN DU MODE INVINCIBLE")
	pass # Replace with function body.

signal winner_round(winner : String)


func _on_animation_choc_toupie_2_timeout() -> void:
	$spr_choc_animation.visible=false
	pass # Replace with function body.
