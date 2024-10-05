extends CollisionShape2D

# Vitesse de mouvement
var speed_init = 400
var speed = speed_init
# Force d'attraction vers le centre
var attraction_strength = 20

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
func _process(delta):
	var direction = Vector2.ZERO
	if speed >0:
		speed=speed_init*exp(-k*(temps.TOT-temps.total_time))
	else:
		speed=0
	print(speed)
	rotation += (speed*2) * delta
	# Détection des touches fléchées
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	
	# Normaliser la direction pour éviter une vitesse diagonale plus rapide
	direction = direction.normalized()

	# Déplacer la toupie
	self.position += direction * speed * delta
	
	# Calculer l'attraction vers le centre
	var center_position = center.position
	var attraction_vector = (center_position - self.position).normalized()
	
	# Appliquer l'attraction
	self.position += attraction_vector * attraction_strength * delta
