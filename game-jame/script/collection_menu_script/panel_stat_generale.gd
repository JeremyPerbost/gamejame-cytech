extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Label.text = "Number of games : " + str(Score.nbr_parties)
	$VBoxContainer/Label2.text = "Maximum speed reached : %.1f KM/H" % (Score.max_speed_tot/1000)
	$VBoxContainer/HBoxContainer/Label4.text = "player1 : " + str(int(Score.total_distance_p1)) + " KM |"
	$VBoxContainer/HBoxContainer/Label5.text = "player2 : " + str(int(Score.total_distance_p2)) + " KM"

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
