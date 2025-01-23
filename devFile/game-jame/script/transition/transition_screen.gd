extends CanvasLayer

func transition(target: String) -> void:
	$AnimationPlayer.play("default")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("default")
	
