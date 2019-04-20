extends KinematicBody2D

onready var nacho = preload("res://Scenes/Nacho.tscn")


onready var tile_map = get_node("../TileMap")

var avocados_rescued = 0

var g = 600.0
var g_multi = 1
var g_multi2 = 1
var vel = Vector2()
var snap = true
var acel = 3000

var lives = 4
var health = 100
var nacho_count = 50

var checkpoint_pos = Vector2(100,2000)

func _ready():
	get_node("../Hud/HealthBar").value = health


func is_on_spike():
	var tile_pos = tile_map.world_to_map(position)
	var td = tile_map.get_cellv(Vector2(tile_pos.x, tile_pos.y + 1)) 
	var tr = tile_map.get_cellv(Vector2(tile_pos.x+1, tile_pos.y))
	var tl = tile_map.get_cellv(Vector2(tile_pos.x-1, tile_pos.y))
	var tu = tile_map.get_cellv(Vector2(tile_pos.x, tile_pos.y - 1))
	
	var on_spike = (td == 4 and is_on_floor()
					or is_on_wall() and(tr == 4 or tl == 4)
					or is_on_ceiling() and tu == 4)
	
	return on_spike

func _process(delta):


	get_node("../Hud/Nachos/Count").text = str(nacho_count)
	
	get_node("../Hud/ac").text = "Avocados Left = " + str(7-avocados_rescued)
	if avocados_rescued == 7:
		get_node("../Hud/ac").text == "Go to the final battle"
		
	if is_on_spike():
		die()
	
	do_gravity(delta) # calls the gravit function
	
	# If the player is trying to go against a wall
	# the fall speed is reduced
	if ((Input.is_action_pressed("ui_left") or 
	   Input.is_action_pressed("ui_right"))
	   and is_on_wall()):
		vel.y = clamp(vel.y,-500,100)
		$AnimatedSprite.animation = "Wall"
		
	# If the player collides with the cealing, the y
	# velocity is canceled
	if is_on_ceiling():
		vel.y = 1 # 1 instead of 0, otherwise the player would stuck in the ceiling
		
	# Horizontal movment and animation
	if Input.is_action_pressed("ui_left") and not is_on_wall():
		vel.x -= acel*delta
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.speed_scale = 1
		if $Timer.time_left == 0 and $MelleTimer.time_left == 0:
			$AnimatedSprite.animation = "Walking"
	elif Input.is_action_pressed("ui_right") and not is_on_wall():
		vel.x += acel*delta
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.speed_scale = 1
		if $Timer.time_left == 0 and $MelleTimer.time_left == 0:
			$AnimatedSprite.animation = "Walking"
	elif abs(vel.x) > 10 and is_on_floor(): # Player deceleration
		vel.x -= (abs(vel.x)/vel.x) * 10 + vel.x * 0.1
		if $Timer.time_left == 0 and $MelleTimer.time_left == 0:
			$AnimatedSprite.speed_scale = 0.5
	elif is_on_floor():
		vel.x = 0
		$AnimatedSprite.speed_scale = 1
		if $Timer.time_left == 0 and $MelleTimer.time_left == 0:
			$AnimatedSprite.animation = "Idle"
	
	# This is to make sure the player stay in colision whith the wall
	# otherwise the wall jump wouldn't work
	if is_on_wall() and vel.x > 0:
		vel.x = 5
	elif is_on_wall():
		vel.x = -5
	
	# Jump animation
	if not is_on_floor() and not is_on_wall() and $Timer.time_left == 0 and $MelleTimer.time_left == 0:
		$AnimatedSprite.animation = "Jump"
	
	# Calls jump function when the player hits jump
	if Input.is_action_just_pressed("jump"):
		jump()
	
	if Input.is_action_just_pressed("trow") and nacho_count > 0:
		trow_nachos()
	
	if Input.is_action_pressed("Melle") and $MelleTimer.time_left == 0:
		melle_atack()
		if $AnimatedSprite.flip_h == true:
			$RayCast2D.cast_to = Vector2(100,0)
			$RayCast2D.position = Vector2(-50,0)
		else:
			$RayCast2D.position = Vector2(50,0)
			$RayCast2D.cast_to = Vector2(-100,0)
	
	# Clamps the x velocity
	vel.x = clamp(vel.x,-200,200)

	move_and_slide_with_snap(vel,Vector2(0,1),Vector2(0,-1),snap,4,0.75,false)
	snap = true

func melle_atack():
	$MelleTimer.start()
	$AnimatedSprite.animation = "Melle"
		
	if $RayCast2D.is_colliding():
		var par = $RayCast2D.get_collider().get_parent()
		if par.name == "Enemy":
			par.damage(10)
			#print(par.name)
			
		if par.get_parent().name == "Boss":
			par.get_parent().damage(par.name(), 10)
	

# Trow function
func trow_nachos():
	$Timer.start()
	
	if is_on_floor():
		if abs(vel.x) < 10:
			$AnimatedSprite.animation = "IdleAtack"
		else:
			$AnimatedSprite.animation = "WalkingAtack"
	elif not is_on_wall():
		$AnimatedSprite.animation = "JumpAtack"
	
	var nachoi = nacho.instance()
	get_node("..").add_child(nachoi)
	
	nachoi.position = position - Vector2(0,8)
	
	if $AnimatedSprite.flip_h == true:
		nachoi.vel = Vector2(10,0)
	else:
		nachoi.vel = Vector2(-10,0)
	nacho_count -= 1
	get_node("../Hud/Nachos/Count").text = str(nacho_count)
# jump function	
func jump():
	if is_on_floor(): # if is in the floor, normal jump
		snap = false
		vel.y = -250	
	elif is_on_wall(): # if is in the wall, wall jump
		snap = false
		vel.y = -250
		vel.x = -(abs(vel.x)/(vel.x+0.001))*200
		$AnimatedSprite.animation = "Wall"
	
# Gravity function
func do_gravity(delta):
	
	if not is_on_floor() and vel.y < 500:
		vel.y += g*delta*g_multi*g_multi2
	
	if Input.is_action_pressed("jump"):
		g_multi2 = 0.6
	else:
		g_multi2 = 1
	
	if is_on_floor():
		vel.y = 5
		snap = true
		acel = 3000
	else:
		acel = 1000
	
	if vel.y > 0:
		g_multi = 2
	else:
		g_multi = 1

func die():
	health = 100
	$DamageTimer.wait_time = 1
	position = checkpoint_pos

func damage(var damage: float):
	
	if $DamageTimer.time_left == 0:
		health -= damage
		$DamageTimer.wait_time = 0.25
		$DamageTimer.start()
	
	if health <= 0:
		die()
	
	get_node("../Hud/HealthBar").value = health