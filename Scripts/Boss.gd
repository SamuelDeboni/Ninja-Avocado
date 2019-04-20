extends Node2D

onready var laser = preload("res://Scenes/Laser.tscn")

onready var minigun_textures = [
	load("res://Sprites/Boss/Pinnaple Mastermind Minigun_Spining_1.png"),
	load("res://Sprites/Boss/Pinnaple Mastermind Minigun_Spining_2.png"),
	load("res://Sprites/Boss/Pinnaple Mastermind Minigun.png"),
	load("res://Sprites/Boss/Pinnaple Mastermind Minigun_SpiningUp.png")
]

var minigun_pattern = 0
var curr_minigun_tex = 0
var minigun_rotating_dir = true


var body_health = 100
var tail_health = 50
var minigun_health = 50

var paused = true

func _ready():
	$Minigun/FireTimer.connect("timeout", self, "minigun_fire")
	$Minigun/PatternTimer.connect("timeout", self, "minigun_change_pattern")
	$Minigun/SpinUpTimer.connect("timeout", self, "minigun_start_firing")
	$Tail/FireTimer.connect("timeout", self, "tail_fire")
	
	$Minigun/FireTimer.paused = true
	$Minigun/PatternTimer.paused = true
	$Minigun/SpinUpTimer.paused = true
	$Tail/FireTimer.paused = true
	
func _process(delta):
	if not paused:
		var player = get_tree().get_root().find_node("NinjaAvocado", true, false)
		if player != null && tail_health > 0:
			aim_tail(player.get_global_position())
			
		if $Minigun.rotation_degrees >= 60:
			minigun_rotating_dir = false
		if $Minigun.rotation_degrees < 0:
			minigun_rotating_dir = true
		
		if minigun_health > 0:
			if minigun_pattern == 0 && $Minigun.rotation > 0:
				$Minigun.rotate(-delta)
				$Minigun.rotation = max($Minigun.rotation, 0)
			if minigun_pattern == 1:
				$Minigun.rotate(delta if minigun_rotating_dir else -delta)
			if minigun_pattern == 2:
				$Minigun.rotate(2 * delta if minigun_rotating_dir else -2 * delta)

func activate():
	paused = false
	$Minigun/FireTimer.paused = false
	$Minigun/PatternTimer.paused = false
	$Minigun/SpinUpTimer.paused = false
	$Tail/FireTimer.paused = false

func aim_tail(player_pos):
	var tip_pos = Vector2(-55, -48)
	$Tail.look_at(player_pos - tip_pos)
	$Tail.rotation_degrees -= 150
	
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
	
func tail_fire():
	var laseri = laser.instance()
	$Tail.add_child(laseri)
	laseri.position += Vector2(-55, -48)
	laseri.rotation_degrees -= 30
	
	var laser_pos = laseri.get_global_position()
	var laser_rot = laseri.get_global_rotation()
	$Tail.remove_child(laseri)
	get_tree().get_root().add_child(laseri)
	laseri.set_global_position(laser_pos)
	laseri.set_global_rotation(laser_rot)
	
	laseri.vel = -500

func damage(part, dmg):
	print(part)
	match part:
		"Body":
			body_health -= dmg
			if body_health <= 0:
				print("yay, you won, congratulations or something")
		"Tail":
			tail_health -= dmg
			if tail_health <= 0:
				$Tail/FireTimer.paused = true
				$Tail/Area2D/CollisionShape2D.disabled = true
				$Tail.texture = load("res://Sprites/Boss/Pinnaple Mastermind BrokenTail.png")
		"Minigun":
			minigun_health -= dmg
			if minigun_health <= 0:
				$Minigun/FireTimer.paused = true
				$Minigun/SpinUpTimer.paused = true
				$Minigun/PatternTimer.paused = true
				$Minigun/Area2D/CollisionShape2D.disabled = true
				$Minigun.texture = load("res://Sprites/Boss/Pinnaple Mastermind BrokenMinigun.png")
	
func _on_Body_entered(body):
	if body.name != "NinjaAvocado":
		damage(0, 5)
		body.queue_free()

func _on_Tail_entered(body):
	if body.name != "NinjaAvocado":
		damage(1, 5)
		body.queue_free()
	
func _on_Minigun_entered(body):
	if body.name != "NinjaAvocado":
		damage(2, 5)
		body.queue_free()