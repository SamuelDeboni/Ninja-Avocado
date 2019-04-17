extends KinematicBody2D


var g = 1200.0
var g_multi = 1
var g_multi2 = 1
var vel = Vector2()
var snap = true
var acel = 3000

func _ready():
	pass 


func _process(delta):
	
	
	do_gravity(delta)
	
	if ((Input.is_action_pressed("ui_left") or
	   Input.is_action_pressed("ui_right"))
	   and is_on_wall()):
		vel.y = clamp(vel.y,-1000,100)
		
	if is_on_ceiling():
		vel.y = 1
	
	if Input.is_action_pressed("ui_left") and not is_on_wall():
		vel.x -= acel*delta
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.animation = "Walking"
	elif Input.is_action_pressed("ui_right") and not is_on_wall():
		vel.x += acel*delta
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.animation = "Walking"
	elif abs(vel.x) > 10 and is_on_floor():
		vel.x -= (abs(vel.x)/vel.x) * 10 + vel.x * 0.1
		$AnimatedSprite.speed_scale = 0.5
	elif is_on_floor():
		vel.x = 0
		$AnimatedSprite.speed_scale = 1
		$AnimatedSprite.animation = "Idle"
	
	if is_on_wall() and vel.x > 0:
		vel.x = 5
	elif is_on_wall():
		vel.x = -5
	
	if not is_on_floor() and not is_on_wall():
		$AnimatedSprite.animation = "Jump"
	
	
	if Input.is_action_just_pressed("ui_up"):
		jump()
	
	vel.x = clamp(vel.x,-200,200)
	move_and_slide_with_snap(vel,Vector2(0,1),Vector2(0,-1),snap,4,0.75,false)
	snap = true
		
func jump():
	if is_on_floor():
		snap = false
		vel.y = -400	
	elif is_on_wall():
		snap = false
		vel.y = -400
		vel.x = -(abs(vel.x)/(vel.x+0.001))*200
		

func do_gravity(delta):
	if not is_on_floor() and vel.y < 800:
		vel.y += g*delta*g_multi*g_multi2
	
	if Input.is_action_pressed("ui_up"):
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