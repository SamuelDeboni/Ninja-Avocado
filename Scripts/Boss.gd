extends Node2D

onready var laser = preload("res://Scenes/Laser.tscn")

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

func _process(delta):
	aim_tail(get_tree().get_root().find_node("NinjaAvocado", true, false).get_global_position())

func aim_tail(player_pos):
	var tip_pos = Vector2(-55, -48)
	$Tail.look_at(player_pos - tip_pos)
	$Tail.rotation_degrees += -150
	
func minigun_change_pattern():
	$Minigun.rotation_degrees = 45
	$Minigun/FireTimer.paused = true
	
func minigun_start_firing():
	$Minigun/FireTimer.paused = false
	
func minigun_fire():
	var laseri = laser.instance()
	$Minigun.add_child(laseri)
	laseri.position += Vector2(-36, -4)
	
	var laser_pos = laseri.get_global_position()
	var laser_rot = laseri.get_global_rotation()
	$Minigun.remove_child(laseri)
	get_tree().get_root().add_child(laseri)
	laseri.set_global_position(laser_pos)
	laseri.set_global_rotation(laser_rot)
	
	laseri.vel = -500
	
	curr_minigun_tex = (curr_minigun_tex + 1) % 2
	$Minigun.texture = minigun_firing_textures[curr_minigun_tex]