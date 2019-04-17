extends Node2D

const MAX_DLEVEL = 1 # Maximum difficulty level
const SEGMENT_SIZE = 384

func generate_level():
	var level = [[0,0,0,0],
				 [0,0,0,0],
				 [0,0,0,0],
				 [0,0,0,0]]
	
	seed(OS.get_time().second + OS.get_time().minute + OS.get_time().hour + OS.get_ticks_msec())
	seed(randi())
	
	var gx = 0
	var gy = 0
	gx = int(rand_range(0,4))
	level[gx][gy] = 1
	var dir = int(rand_range(0,2))
	
	for i in range(0,16):
		
		var can_d = gy+1 <= 3
		var can_l = gx-1 >= 0
		var can_r = gx+1 <= 3
		var cant_sides = (dir == 0 and not can_r) or (dir == 1 and not can_l)
		
		if can_d and (randf() > 0.6 or cant_sides):
			gy += 1	
			var r = int(rand_range(0,2))
			dir = r
			print(r)
		else:
			if dir == 0 and can_r:
				gx += 1
			elif dir == 1 and can_l:
				gx -= 1
		
		if not can_d and cant_sides:
			level[gx][gy] = 3
			break
		
		level[gx][gy] = 2
	
	for y in range(0,4):
		for x in range(0,4):
			if level[x][y] == 2:
				if x != 0 and level[x-1][y] != 0 and x != 3 and level[x+1][y] != 0:
					level[x][y] = 4
				if y != 0 and level[x][y-1] != 0 and y != 3 and level[x][y+1] != 0:
					level[x][y] = 5
	
	#for y in range(0,4):
	#	for x in range(0,4):
	#		if level[x][y] == 4:
	#			if y != 3 and level[x][y+1] == 5 or y != 0 and level[x][y-1] == 5:
	#				level[x][y] = 2
	#			#if y != 3 and level[x][y+1] == 4 or y != 0 and level[x][y-1] == 4:
	#			#	level[x][y] = 2
	#			#if y != 3 and level[x][y+1] == 6 or y != 0 and level[x][y-1] == 6:
	#			#	level[x][y] = 2
	#		
	#		elif level[x][y] == 5:
	#			if x != 3 and level[x+1][y] == 4 or x != 0 and level[x-1][y] == 4:
	#				level[x][y] = 2
	#			#if x != 3 and level[x+1][y] == 5 or x != 0 and level[x-1][y] == 5:
	#				#level[x][y] = 2
	#			#if x != 3 and level[x+1][y] == 6 or x != 0 and level[x-1][y] == 6:
	#				#level[x][y] = 2

			
	# 1 Exit
	# 2 Intercection
	# 3 Entrace
	# 4 Corridor
	# 5 Vertical Corridor
	# 6 Open area
		
	instantiate_level(level, 0)
	print(level[0])
	print(level[1])
	print(level[2])
	print(level[3])

func instantiate_level(layout, level_number):
	# `layout` is the level layout returned by `generate_level`.
	# `level_number` is the index of the level we're in. This is important to
	# know the difficulty of the level
	
	var segment_pool = []
	var dlevel = level_number / 5 # `dlevel` stands for "difficulty level"
	dlevel = min(dlevel, MAX_DLEVEL)
	
	for d in range(dlevel + 1):
		# This presumes that every diffculty level has the same number of
		# segments. Ideally, we would look in the segment directory to find 
		# which segments exist, but for now this is good enough.
		for i in range(2):
				segment_pool.push_back("-%02d-%02d.tscn" % [d, i])
	
	#print(segment_pool)
	
	for y in range(4):
		for x in range(4):
			var seg = ""
			match layout[abs(x-3)][y]:
				6:
					seg = "Ope" + segment_pool[randi() % segment_pool.size()]
				5:
					seg = "Ver" + segment_pool[randi() % segment_pool.size()]
				4:
					seg = "Cor" + segment_pool[randi() % segment_pool.size()]
				3:
					seg = "Entrance.tscn"
				2:
					seg = "Seg" + segment_pool[randi() % segment_pool.size()]
				1:
					seg = "Exit.tscn"
				0:
					seg = "Fill.tscn"
				_:
					pass
			
			if seg != "":
				var instance = load("res://Scenes/LevelPiece/" + seg).instance()
				instance.position = Vector2(x, y) * SEGMENT_SIZE
				#print(seg, instance.position)
				
				# I'm using `call_deferred` here because `add_child` fails if
				# it is called by `_ready`
				get_tree().get_root().call_deferred("add_child", instance)
				if seg == "Entrance.tscn":
					$NinjaAvocado.position = Vector2(x, y) * SEGMENT_SIZE + Vector2(190,128) 

func _ready():
	generate_level()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_page_up"):
		get_tree().reload_current_scene()