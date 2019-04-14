extends Node2D

const MAX_DLEVEL = 4 # Maximum difficulty level
const SEGMENT_SIZE = 8

func generate_level():
	var level = [[0,0,0,0],
				 [0,0,0,0],
				 [0,0,0,0],
				 [0,0,0,0]]
	
	#var map_seed = 2624895
	#seed(map_seed)
	
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
		
		if can_d and (randf() > 0.75 or cant_sides):
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
		for i in range(1):
				segment_pool.push_back("Seg-%02d-%02d.tscn" % [d, i])
	
	#print(segment_pool)
	
	for y in range(4):
		for x in range(4):
			var seg = ""
			match layout[y][x]:
				1:
					seg = "Entrance.tscn"
				2:
					seg = segment_pool[randi() % segment_pool.size()]
				3:
					seg = "Exit.tscn"
				_:
					pass
			
			if seg != "":
				var instance = load("res://Scenes/LevelPiece/" + seg).instance()
				instance.position = Vector2(x, y) * SEGMENT_SIZE
				#print(seg, instance.position)
				
				# I'm using `call_deferred` here because `add_child` fails if
				# it is called by `_ready`
				get_tree().get_root().call_deferred("add_child", instance)

func _ready():
	generate_level()