extends Node2D

var minigun_pattern = 0

onready var minigun_firing_textures = [
	load("res://Sprites/Boss/Pinnaple Mastermind Minigun_Spining_1.png"),
	load("res://Sprites/Boss/Pinnaple Mastermind Minigun_Spining_2.png")
]

var curr_minigun_tex = 0


func _ready():
	aim_tail(Vector2(0, 0))
	$Minigun/FireTimer.connect("timeout", self, "minigun_fire")
	minigun_start_firing()

func aim_tail(player_pos):
	var tip_pos = Vector2(-55, -48)	
	$Tail.look_at(player_pos - tip_pos)
	$Tail.rotation_degrees += 210
	
func minigun_change_pattern():
	$Minigun.rotation_degrees = 0
	$Minigun/FireTimer.paused = true
	
func minigun_start_firing():
	$Minigun/FireTimer.paused = false
	
func minigun_fire():
	curr_minigun_tex += 1
	curr_minigun_tex %= 2
	$Minigun.texture = minigun_firing_textures[curr_minigun_tex]