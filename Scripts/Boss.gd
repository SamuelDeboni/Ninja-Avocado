extends Node2D

onready var laser = preload("res://Scenes/Laser.tscn")

var minigun_pattern = 0
onready var minigun_textures = [
	load("res://Sprites/Boss/Pinnaple Mastermind Minigun_Spining_1.png"),
	load("res://Sprites/Boss/Pinnaple Mastermind Minigun_Spining_2.png"),
	load("res://Sprites/Boss/Pinnaple Mastermind Minigun.png"),
	load("res://Sprites/Boss/Pinnaple Mastermind Minigun_SpiningUp.png")
]
var curr_minigun_tex = 0
var minigun_rotating_dir = true


func _ready():
	aim_tail(Vector2(0, 0))
	$Minigun/FireTimer.connect("timeout", self, "minigun_fire")
	$Minigun/PatternTimer.connect("timeout", self, "minigun_change_pattern")
	$Minigun/SpinUpTimer.connect("timeout", self, "minigun_start_firing")
	minigun_start_firing()

func _process(delta):
	aim_tail(get_tree().get_root().find_node("NinjaAvocado", true, false).get_global_position())
	if $Minigun.rotation_degrees >= 60:
		minigun_rotating_dir = false
	if $Minigun.rotation_degrees < 0:
		minigun_rotating_dir = true
		
	if minigun_pattern == 0 && $Minigun.rotation > 0:
		$Minigun.rotate(-delta)
		$Minigun.rotation = max($Minigun.rotation, 0)
	if minigun_pattern == 1:
		$Minigun.rotate(delta if minigun_rotating_dir else -delta)
	if minigun_pattern == 2:
		$Minigun.rotate(2 * delta if minigun_rotating_dir else -2 * delta)
	
	

func aim_tail(player_pos):
	var tip_pos = Vector2(-55, -48)
	$Tail.look_at(player_pos - tip_pos)
	$Tail.rotation_degrees += -150
	
func minigun_change_pattern():
	minigun_pattern += 1
	minigun_pattern %= 3
	
	$Minigun/FireTimer.paused = true
	$Minigun.texture = minigun_textures[2]
	$Minigun/SpinUpTimer.start()
	
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
	$Minigun.texture = minigun_textures[curr_minigun_tex]