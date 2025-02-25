extends CanvasLayer
@onready var audio_transition=$audio_transition
func transition(target: String) -> void:
	audio_transition.play()
	$AnimationPlayer.play("default")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("default")
	
