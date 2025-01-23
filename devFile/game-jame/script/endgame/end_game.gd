extends Node2D

var player1_title = preload("res://images/ecran_de_fin/player1win.png")
var player2_title = preload("res://images/ecran_de_fin/player2win.png")
@onready var replay_button = $rejouer_btn as Button #charge les assets
@onready var title_btn = $ecran_titre_btn as Button
var rotate_speed : float =0.04
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	replay_button.button_down.connect(replay)#actionne quand le button est pressioné
	title_btn.button_down.connect(return_title_screen)
	print("Score.gagnant="+Score.gagnant)
	if Score.gagnant == "player1":
		$player_title.texture = player1_title
		$toupie_gagnante.texture = load(Skins.P1)
	elif Score.gagnant == "player2":
		$player_title.texture = player2_title
		$toupie_gagnante.texture =load(Skins.P2)
	else:
		print("ERREUR PAS DE GAGNANT !")
	await $Animation_endgame.animation_finished
	$Price.play("default")
	await $Price.animation_finished
	$Price.play_backwards("default")
	pass # Replace with function body.
func _process(delta: float) -> void:
	$toupie_gagnante.rotation +=rotate_speed* delta
	pass
func replay() -> void:
	Score.score_player1=0
	Score.score_player2=0
	Score.gagnant=""
	TransitionScreen.transition("res://maps/toupie.tscn")
	pass # Replace with function body.
func return_title_screen() -> void:
	TransitionScreen.transition("res://maps/menuprincipal.tscn")
	pass # Replace with function body.
