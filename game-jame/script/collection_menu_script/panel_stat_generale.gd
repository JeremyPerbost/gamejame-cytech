extends Panel
var pourcentage=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Label.text = "Number of games : " + str(Score.nbr_parties)
	$VBoxContainer/Label2.text = "Maximum speed reached : %.2f KM/H" % (Score.max_speed_tot/100)
	$VBoxContainer/Label4.text = "player1 : %.3f KM"% Score.total_distance_p1
	$VBoxContainer/Label5.text = "player2 : %.3f KM"% Score.total_distance_p2
	
	if Score.nbr_parties_gagnees_ia==0:#division par zero
		pourcentage=0
	else:
		pourcentage=((Score.nbr_parties_gagnees_ia/Score.nbr_parties_ia)*100)
	$VBoxContainer/Label6.text = "Percentage of successes against AI : %.1f"% pourcentage

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
