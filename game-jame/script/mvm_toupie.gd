extends CollisionShape2D

# Vitesse de mouvement
var speed_init = 400
var speed = speed_init
# Force d'attraction vers le centre
var attraction_strength = 900000

# Référence au centre
var center
var temps
var k = 0.01  # Constante de friction
# Called when the node enters the scene tree for the first time.
func _ready():
	# Assurez-vous que le nœud "centre" est bien nommé dans votre scène
	center = get_parent().get_node("centre") 
	temps = get_node("/root/Toupie") 
	if center == null:
		print("Le nœud 'centre' n'a pas été trouvé dans la scène.")
	if temps == null:
		print("Le nœud 'temps	' n'a pas été trouvé dans la scène.")
# Called every frame. 'delta' is the elapsed time since the previous frame.
# Appelé à chaque frame. 'delta' est le temps écoulé depuis la dernière frame.
func _process(delta):
	var direction = Vector2.ZERO

	# Gestion du ralentissement exponentiel
	if speed > 0:
		speed = speed_init * exp(-k * (temps.TOT - temps.total_time))
	else:
		speed = 0
	print(speed)

	# Rotation en fonction de la vitesse
	rotation += (speed /10) * delta

	# Détection des touches pour le déplacement du joueur
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()

	# Calculer la distance entre la toupie et le centre
	var distance_to_center = (center.position - self.position).length()

	# Si la toupie est trop proche du centre, l'attraction devient très faible pour la laisser s'échapper
	var min_distance = 650  # Ajuste ce seuil en fonction de la taille de ta scène ou toupie
	var attraction_factor = 1.0
	if distance_to_center < min_distance:
		attraction_factor = distance_to_center / min_distance  # Réduit l'attraction progressivement

	# Calculer la force d'attraction proportionnelle à la distance, avec une limite et un facteur d'attraction dynamique
	var attraction_strength_dynamic = clamp(attraction_strength * (1 / max(distance_to_center, 1)), 0, 500) * attraction_factor

	# Calculer le vecteur d'attraction vers le centre
	var attraction_vector = (center.position - self.position).normalized() * attraction_strength_dynamic

	# Combiner la direction du joueur avec la force d'attraction
	var combined_force = direction * speed + attraction_vector

	# Déplacer la toupie en fonction de la force combinée
	self.position += combined_force * delta


