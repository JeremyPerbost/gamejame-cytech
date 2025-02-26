extends Node

var musique_en_cours:AudioStreamPlayer
var curseur:float=0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	musique_en_cours=AudioStreamPlayer.new()
	add_child(musique_en_cours)
	musique_en_cours.volume_db=-12
	
func jouer(stream: AudioStream):
	if musique_en_cours.stream==stream:#securite pour ne pas relancer la meme musique
		return
	if musique_en_cours:
		curseur = musique_en_cours.get_playback_position()
		musique_en_cours.stop()
	musique_en_cours.stream=stream
	musique_en_cours.stream.loop=true
	musique_en_cours.play(curseur)
func stop():
	musique_en_cours.stop()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
