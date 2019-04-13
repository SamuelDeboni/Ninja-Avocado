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
	
	if not is_on_floor() and vel.y < 800:
		vel.y += g*delta*g_multi*g_multi2
	
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
	
	if Input.is_action_pressed("ui_up"):
		g_multi2 = 0.6
	else:
		g_multi2 = 1
	
	if is_on_ceiling():
		vel.y = 1
	
	if Input.is_action_pressed("ui_left") and not is_on_wall():
		vel.x -= acel*delta
	elif Input.is_action_pressed("ui_right") and not is_on_wall():
		vel.x += acel*delta
	elif abs(vel.x) > 10 and is_on_floor():
		vel.x -= (abs(vel.x)/vel.x) * 10 + vel.x * 0.1
	elif is_on_floor():
		vel.x = 0
	
	if is_on_wall() and vel.x > 0:
		vel.x = 1
	elif is_on_wall():
		vel.x = -1
	
	print(is_on_wall())
		
	vel.x = clamp(vel.x,-300,300)
		
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		vel.y = -500
		snap = false
	elif Input.is_action_just_pressed("ui_up") and is_on_wall():
		vel.y = -500
		vel.x = (-abs(vel.x)/(vel.x+0.001))*300
	
	move_and_slide_with_snap(vel,Vector2(0,1),Vector2(0,-1),snap,4,0.75,false)
	snap = true
