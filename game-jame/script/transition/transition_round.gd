extends CanvasLayer
func transition(target: String) -> void:
	#preparation en replacant les données
	play_musique()
	$player1.texture=load(Skins.P1)
	$player2.texture=load(Skins.P2)
	$P1.text=str(Score.score_player1)
	$P2.text=str(Score.score_player2)
	#-------------------------------------
	$AnimationPlayer.play("default")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("RESET")
	get_tree().change_scene_to_file(target)
func play_musique():
	#choisir quelle musique jouer
	if Score.score_player1 == 0 and Score.score_player2 == 0:
		MusiqueManager.jouer(load("res://sons/combat/combat_1_loop.mp3"))
	elif (Score.score_player1 == 1 and Score.score_player2 in [0, 1]) or (Score.score_player2 == 1 and Score.score_player1 == 0):
		MusiqueManager.jouer(load("res://sons/combat/combat_2_loop.mp3"))
	elif (Score.score_player1 in [1, 2] and Score.score_player2 in [1, 2]) or (Score.score_player1 == 2 and Score.score_player2 == 0) or (Score.score_player2 == 2 and Score.score_player1 == 0):
		MusiqueManager.jouer(load("res://sons/combat/combat_3_loop.mp3"))
	pass
