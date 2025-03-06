extends Node

var score_player1 : int = 0
var score_player2 : int = 0
var gagnant= "" #player1 ou player2
var mode_de_jeu=0;#0=multijoueur local 1=Solo

var is_transition_playing=false
#----statP1---
var max_speed_player1=0
var nbr_booster_speciauxP1=0
var nbr_booster_communP1=0
var distanceP1=0
var nbr_bordsP1=0
#-----statP2------
var max_speed_player2=0
var nbr_booster_speciauxP2=0
var nbr_booster_communP2=0
var distanceP2=0
var nbr_bordsP2=0
#------STAT GLOBALES-----
var nbr_parties=0
var max_speed_tot=0
var total_distance_p1=0
var total_distance_p2=0
