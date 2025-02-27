extends Node

var save_path = "user://variable.save"
var variables_globales = {}

# 🔥 Fonction principale pour sauvegarder les données

# 🔥 Fonction pour charger les données
func Load():
	if FileAccess.file_exists(save_path):
		var fichier = FileAccess.open(save_path, FileAccess.READ)
		var content = fichier.get_as_text()
		fichier.close()
		
		var data = JSON.parse_string(content)
		if data and "variables_globales" in data:
			variables_globales = data["variables_globales"]
			appliquer_donnees()  # ✅ Applique les valeurs chargées aux objets
			print("[LOAD] Sauvegarde chargée avec succès !")
		else:
			print("[ECHEC LOAD] Données corrompues ou incomplètes.")
	else:
		print("[ECHEC LOAD] Aucun fichier de sauvegarde trouvé.")
func mettre_a_jour_variables_globales():
	# 🔄 Met à jour toutes les valeurs stockées avant la sauvegarde
	variables_globales["arene"] = Arene.arene
	variables_globales["taille"] = Arene.taille
	variables_globales["collectables"] = Collectables.collectables.duplicate()
	variables_globales["P1"] = Skins.P1
	variables_globales["P2"] = Skins.P2
	variables_globales["camera_shaking"] = Parametres.camera_shaking

	# ✅ Debug : Vérifions que les données sont mises à jour avant la sauvegarde
	print("[DEBUG] Contenu de variables_globales avant sauvegarde :", variables_globales)

func Save():
	mettre_a_jour_variables_globales()  # 🔄 Met à jour toutes les variables avant la sauvegarde
	
	var save_dict = {}  
	save_dict["variables_globales"] = variables_globales  # Stocke le dictionnaire global

	# ✅ Debug : Vérifions que le dictionnaire de sauvegarde est bien formé
	print("[DEBUG] Données enregistrées dans JSON :", save_dict)

	# 🔥 Essayons d'ouvrir le fichier pour écrire
	var fichier = FileAccess.open(save_path, FileAccess.WRITE)
	if fichier:
		fichier.store_string(JSON.stringify(save_dict, "\t"))  # Beautifie le JSON pour lecture facile
		fichier.close()
		print("[SAVE] Sauvegarde réussie !")
	else:
		print("[ERREUR SAVE] Impossible d'ouvrir le fichier de sauvegarde.")

func appliquer_donnees():
	print("[DEBUG] Contenu de variables_globales :", variables_globales)  # Vérifie ce qui est chargé

	Arene.arene = variables_globales.get("arene", "res://images/Menus/background/background_combat_pierre.png")
	print("[DEBUG] Arene.arene :", Arene.arene)  # Vérifie si la valeur change

	Arene.taille = variables_globales.get("taille", 100)
	print("[DEBUG] Arene.taille :", Arene.taille)

	Collectables.collectables = variables_globales.get("collectables", [0, 0, 0, 0, 0, 0, 0, 0])
	print("[DEBUG] Collectables.collectables :", Collectables.collectables)

	Skins.P1 = variables_globales.get("P1", "res://images/skins/P1.png")
	print("[DEBUG] Skins.P1 :", Skins.P1)

	Skins.P2 = variables_globales.get("P2", "res://images/skins/P2.png")
	print("[DEBUG] Skins.P2 :", Skins.P2)

	Parametres.camera_shaking = variables_globales.get("camera_shaking", true)
	print("[DEBUG] Parametres.camera_shaking :", Parametres.camera_shaking)

# 🔹 Fonction pour sauvegarder une seule valeur
func sauvegarder_valeur(nom, valeur):
	variables_globales[nom] = valeur

# 🔹 Fonction pour récupérer une valeur sauvegardée
func charger_valeur(nom, valeur = null):
	return variables_globales.get(nom, valeur)
