extends Area2D
# Vitesse de mouvement
var speed_init = 60
var speed = speed_init
# Force d'attraction vers le centre
var attraction_strength = 400
# Vélocité de la toupie
var velocity = Vector2.ZERO

# Référence au centre
var center
var temps
var k = 0.01  # Constante de friction

func _ready():
	center = get_parent().get_node("../centre")
	temps = get_node("/root/Toupie")
	if center == null:
		print(" TP2 : Le nœud 'centre' n'a pas été trouvé dans la scène.")
	if temps == null:
		print("TP2 : Le nœud 'temps' n'a pas été trouvé dans la scène.")

func _process(delta):
	var direction = Vector2.ZERO

	# Gestion du ralentissement exponentiel
	if speed > 0:
		speed = speed_init * exp(-k * (temps.TOT - temps.total_time))
	else:
		speed = 0
	rotation += (speed /3) * delta
	# Détection des touches pour le déplacement du joueur
	if Input.is_action_pressed("ui_Z"):
		direction.y -= 1
	if Input.is_action_pressed("ui_S"):
		direction.y += 1
	if Input.is_action_pressed("ui_Q"):
		direction.x -= 1
	if Input.is_action_pressed("ui_D"):
		direction.x += 1

	# Normaliser la direction si elle n'est pas nulle
	if direction != Vector2.ZERO:
		direction = direction.normalized()

	# Calculer la distance entre la toupie et le centre
	var distance_to_center = (center.position - self.position).length()

	# Si la toupie est trop proche du centre, l'attraction devient très faible pour la laisser s'échapper
	var min_distance = 50  # Ajuste ce seuil en fonction de la taille de ta scène ou toupie
	var attraction_factor = 1
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

	if distance_to_center > 265:
		# Forcer la toupie à rester dans l'arène
		var correction_vector = (self.position - center.position).normalized() * (distance_to_center - 265)
		self.position -= correction_vector  # Ramener la toupie dans l'arène

		# Inverser la vélocité pour simuler un rebond contre le bord
		velocity = (self.position - center.position).normalized() * -velocity.length() * 0.35
	velocity += combined_force * delta

	# Appliquer la vélocité à la position de la toupie
	self.position += velocity * delta

func collision(area):
	var collision_normal = (self.position - area.position).normalized()
	
	# Projeter la vélocité sur la normale de collision pour obtenir la composante à inverser
	var velocity_along_normal = collision_normal.dot(velocity)
	
	# Inverser cette composante pour simuler le rebond
	velocity -= 2 * velocity_along_normal * collision_normal / 1.4

	# Réduire légèrement la vitesse pour simuler une perte d'énergie due à la collision
	velocity *= 0.9
	
	print("TP2 : collision")
func _on_area_entered(area: Area2D) -> void:
	collision(area)
	pass
