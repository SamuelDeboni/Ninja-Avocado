extends Node2D

func generate_level():
	var level = [[0,0,0,0],
				 [0,0,0,0],
				 [0,0,0,0],
				 [0,0,0,0]]
	
	var map_seed = 2624895
	seed(map_seed)
	
	var gx = 0
	var gy = 0
	level[gx][gy] = 1
	var dir = int(rand_range(0,2))
	
	for i in range(0,32):
		
		seed(randi())
		
		var can_d = gy+1 <= 3
		var can_l = gx-1 >= 0
		var can_r = gx+1 <= 3
		var cant_sides = (dir == 0 and not can_r) or (dir == 1 and not can_l)
		
		if can_d and (randf() > 0.9 or cant_sides):
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
			break
		
		level[gx][gy] = 2
	
	print(level[0])
	print(level[1])
	print(level[2])
	print(level[3])


func _ready():
	generate_level()

