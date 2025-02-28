extends CanvasLayer
func transition(target: String) -> void:
	#preparation en replacant les données
	$player1.texture=load(Skins.P1)
	$player2.texture=load(Skins.P2)
	$P1.text=str(Score.score_player1)
	$P2.text=str(Score.score_player2)
	#-------------------------------------
	$AnimationPlayer.play("default")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("RESET")
	get_tree().change_scene_to_file(target)
