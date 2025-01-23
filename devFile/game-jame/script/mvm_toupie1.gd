extends Area2D
#indice du joueur
#TOUPIE1=TOUPIE ROUGE

# Indice du joueur
# TOUPIE1 = TOUPIE ROUGE
var player_index = 0

# Vitesse de mouvement
var speed_init = 80
var speed = speed_init


"""
Dash area
"""
var dashing = true
var dash_timer = 0.3
var dash_acc = 0

# Force d'attraction vers le centre
var attraction_strength = 400

# Vélocité de la toupie
var velocity = Vector2.ZERO

var variable_de_choc = 80
var attraction_factor = 1
var direction = Vector2.ZERO
var rotation_autour_arene = Vector2.ZERO # Vecteur de force de rotation autour du centre de l'arène du à la rotation de la pointe
var sens_rotations = 1 # Sens des aiguilles d'une montre

# Référence au centre
var center
var taille_arene = 265

var temps
var distance_to_center
var min_distance = 50

@onready var duree_effet_trounoir = $effet_trounoir_toupie1
@onready var duree_effet_invincible = $effet_invincible_toupie1
@onready var duree_effet_piege = $effet_piege_toupie1
@onready var memoire_attraction_strength
@onready var spr_choc_animation = $spr_choc_animation

var effet_trou_noir = false # BOOST
var effet_invincible = false # BOOST
var effet_piege = false # BOOST
func _ready():
	spr_choc_animation.play("default")
	center = get_parent().get_node("../centre")
	temps = get_node("/root/Toupie")
	if center == null:
		print(" TP1 : Le nœud 'centre' n'a pas été trouvé dans la scène.")
	if temps == null:
		print("TP1 : Le nœud 'temps' n'a pas été trouvé dans la scène.")
	$htbx_toupie1/spr_toupie1.texture = load(Skins.P1)

func collision(area):
	var toupie2 = get_node("../Area_toupie2")
	if toupie2 == null:
		print("TP1 : toupie2 non trouvée")
	else:
		var collision_normal = (self.position - area.position).normalized()

		# Projeter les vitesses sur la normale de collision
		var toupie2_velocity_along_normal = collision_normal.dot(toupie2.velocity)
		var toupie1_velocity_along_normal = collision_normal.dot(velocity)

		# Calcul de la différence de vitesse relative
		var relative_velocity = toupie1_velocity_along_normal - toupie2_velocity_along_normal

		# Ajuster les vitesses des deux toupies en fonction de la collision
		var impulse = relative_velocity * collision_normal * 0.5

		# Réduire légèrement la vitesse pour simuler une perte d'énergie
		toupie2.velocity += impulse * 1.5 # La toupie 1 gagne une part de l'impulsion ancienne valeur = 0.9
		velocity -= impulse * 1  # La toupie 2 perd une part de l'impulsion ancienne valeur = 0.5
		velocity *= 0.9  # Réduction
		var separation_distance = collision_normal * 10  # Ajuste cette valeur pour le niveau de séparation souhaité
		self.position += separation_distance
		toupie2.position -= separation_distance
		if (toupie2.velocity.length() / 50) >= (velocity.length() / 50) and effet_invincible == false:
			speed -= (float(toupie2.velocity.length()) / variable_de_choc)
	#--------------GESTION DE L'ANIMATION DE CHOC----------------
	spr_choc_animation.visible = true # On montre l'animation
	$animation_choc_toupie1.start() # Démarrer le timer pour montrer l'animation
func _process(delta):
	# Mise à jour des contrôles et direction
	direction = Vector2.ZERO
	var toupie2 = get_node("../Area_toupie2")
	if toupie2 == null:
		print("TP1 : toupie2 non trouvée")
	#-------GESTION DES BONUS--------
	#EFFET TROU NOIR
	if effet_trou_noir == true:
		attraction_strength += 10
	#-------------------------------
	# Gestion du ralentissement exponentiel
	if speed > 0:
		speed -= 0.01
	else:
		speed = 0
		winner_round.emit("player2")
	# Limiter la vitesse
	if speed > 860:
		speed = 800
	# Gestion de la rotation
	rotation += sens_rotations * (speed / 3) * delta
	# Détection des touches pour le déplacement du joueur
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	# Ajoute la détection des axes du joystick gauche
	var joy_x = Input.get_joy_axis(player_index, 0)  # Axe X du joystick gauche
	var joy_y = Input.get_joy_axis(player_index, 1)  # Axe Y du joystick gauche
	var deadzone = 0.2
	if abs(joy_x) > deadzone:
		direction.x += joy_x
	if abs(joy_y) > deadzone:
		direction.y += joy_y
	# Vérifie l'action spéciale
	if Input.is_action_just_pressed("ui_!"):
		if P1Inventaire.place1 != "vide":
			if P1Inventaire.place1 == "attaque":
				print("P1 : UTILISATION ATTAQUE")
				print("velocity=", velocity)
				dashing = true
			elif P1Inventaire.place1 == "esquive":
				print("P1 : UTILISATION ESQUIVE")
				self.position = Vector2(-self.position.x, -self.position.y)
			P1Inventaire.place1 = P1Inventaire.place2
			P1Inventaire.place2 = P1Inventaire.place3
			P1Inventaire.place3 = "vide"
	# Normalise la direction si elle n'est pas nulle
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	# Calculer la distance entre la toupie et le centre
	distance_to_center = (center.position - self.position).length()
	# Si la toupie est trop proche du centre, l'attraction devient très faible pour la laisser s'échapper
	attraction_factor = 1
	if distance_to_center < min_distance:
		attraction_factor = 0  # Réduit l'attraction progressivement
	# Calculer la force d'attraction proportionnelle à la distance, avec une limite et un facteur d'attraction dynamique
	var attraction_strength_dynamic = clamp(0.25 * distance_to_center, 0, 700) * attraction_factor
	var attraction_vector = (center.position - self.position).normalized() * attraction_strength_dynamic
	# Calculer la force centrifuge qui est opposée à l'attraction, et proportionnelle à la vitesse de la toupie
	var speed_magnitude = velocity.length()
	var centrifugal_strength = clamp(speed_magnitude * 0.1, 0, 300)  # Ajuste le coefficient 0.1 et la limite selon les besoins
	var centrifugal_vector = (self.position - center.position).normalized().rotated(PI / 2) * centrifugal_strength
	# Calculer la force appliquée par le joueur
	
	var player_force = direction *speed * 20 if not dashing else direction *dash(speed) * 20
	# Combiner les forces (attraction, direction joueur, centrifuge)
	var combined_force = player_force + attraction_vector * 40 + centrifugal_vector
	# Calcul de la force tangentielle autour de l'arène
	var tangent = (self.position - center.position).normalized().rotated(sens_rotations * PI / 2)
	rotation_autour_arene = tangent * 200
	combined_force += rotation_autour_arene
	# Appliquer la force combinée à la vélocité
	velocity += combined_force * delta
	
	if dashing:
		dash_acc+=delta*10
		if dash_acc>dash_timer:
			dash_acc = 0
			dashing = !dashing

	#-----------------GESTION DES BORDS :------------
	if distance_to_center > taille_arene:
		# Forcer la toupie à rester dans l'arène
		var correction_vector = (self.position - center.position).normalized() * (distance_to_center - taille_arene)
		self.position -= correction_vector
		# Calculer les vecteurs normal et tangent
		var normal = (self.position - center.position).normalized()
		var tangente = normal.rotated(PI / 2)
		# Projeter la vélocité sur normal et tangent
		var normal_component = velocity.dot(normal)
		var tangent_component = velocity.dot(tangente)
		# Modifier la composante normale (inverser et réduire)
		var restitution = 0.35
		var new_normal = -normal_component * restitution
		# Appliquer un coefficient de friction sur la composante tangentielle
		var friction_coeff = 0.9
		var new_tangent = tangent_component * friction_coeff
		# Combiner les nouvelles composantes pour obtenir la nouvelle vélocité
		velocity = normal * new_normal + tangente * new_tangent
		# Limiter la vélocité après correction
		var max_velocity = 500
		if velocity.length() > max_velocity:
			velocity = velocity.normalized() * max_velocity
	#-------------------------------------------------
	#-------Partie de code à optimiser : ----------
	if toupie2 != null:
		var direction_anim = (toupie2.global_position - global_position).normalized()
		spr_choc_animation.rotation = -rotation - 80 + direction_anim.angle() # Correction de la rotation de l'animation
	#----------------------------------------------
	# Appliquer une friction générale pour ralentir progressivement la toupie
	var friction_general = 0.98
	velocity *= friction_general
	# Limiter la vélocité pour éviter des vitesses irréalistes
	var max_velocity_global = 500
	if velocity.length() > max_velocity_global:
		velocity = velocity.normalized() * max_velocity_global
	# Déplacer la toupie
	if effet_piege == false:
		self.position += velocity * delta
		$spr_piege.visible = false
	else:	# GESTION DU BONUS PIEGE
		self.position = Vector2(self.position.x, self.position.y)
		$spr_piege.visible = true
		$spr_piege.rotation = -rotation
		velocity = Vector2.ZERO
func _on_area_entered(area: Area2D) -> void:
	if area.collision_layer==1:
		collision(area)
	if area.collision_layer==2:
		print("TP1: Booster")
		speed=speed+15
		area.queue_free()
	if area.collision_layer==4:
		print("TP1: durability")
		variable_de_choc=variable_de_choc+15
		area.queue_free()
	if area.collision_layer==8:
		print("TP1: trou noire")
		memoire_attraction_strength=attraction_strength
		effet_trou_noir=true
		$spr_trou_noir.visible=true
		duree_effet_trounoir.start()
		area.queue_free()
	if area.collision_layer==16:
		print("TP1: Invincible")
		$spr_invincible.visible=true
		effet_invincible=true
		duree_effet_invincible.start()
		area.queue_free()
	if area.collision_layer==32:
		print("TP1: piege l'autre toupie")
		var toupie2 = get_node("../Area_toupie2")
		toupie2.effet_piege=true
		duree_effet_piege.start()
		area.queue_free()
	pass


func _on_effet_trounoir_toupie_1_timeout() -> void:
	if effet_trou_noir==true:
		$spr_trou_noir.visible=false
		effet_trou_noir=false#Desactiver l'effet du trou noir
		print("TP1: FIN DU TROU NOIR")
		attraction_strength=memoire_attraction_strength
	pass # Replace with function body.



func _on_effet_invincible_toupie_1_timeout() -> void:
	if effet_invincible==true:
		$spr_invincible.visible=false
		effet_invincible=false#Desactiver l'effet du trou noir
		print("TP2: FIN DU MODE INVINCIBLE")
	pass # Replace with function body.

signal winner_round(winner : String)


func _on_animation_choc_toupie_1_timeout() -> void:#timer animation de choc de toupies finie
	$spr_choc_animation.visible=false
	pass # Replace with function body.


func _on_effet_piege_toupie_1_timeout() -> void:
	var toupie2 = get_node("../Area_toupie2")
	if toupie2.effet_piege==true:
		toupie2.effet_piege=false#Desactiver l'effet piege de la toupie 2
		print("TP1: mets fin au piege de la tp2")
	pass # Replace with function body.
	
func dash(base_speed : float)-> float:
	const DASH_MODIFFICATOR = 3
	return base_speed**DASH_MODIFFICATOR
	
