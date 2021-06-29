extends TileMap


onready var noise = OpenSimplexNoise.new()
onready var world_size = Vector2(64, 64)
onready var Mushroom = preload("res://Mushroom.tscn")
onready var Enemy = preload("res://Enemy.tscn")
onready var num_enemies = 5


func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 10
	# gen_world(world_size)


func gen_world(size):
	# inital square of walls
	for y in size.y:
		for x in size.x:
			set_cell(x, y, 0)
	
	# carve out walls with walker
	var world_area = Rect2(Vector2.ZERO, world_size)
	var walker = Walker.new(world_size/2, world_area)
	var map = walker.walk(500, 1)
	walker.queue_free()
	
	for location in map:
		set_cellv(location, 1)
	
	#var used_mush_poses:Array
	for i in Global.total_mushes:
		# choose random position in map
		var mush_pos = map[randi() % map.size()]
#		for pos in used_mush_poses:
#			if mush_pos != pos:
#				used_mush_poses.append(mush_pos)
#				break
		
		var new_mush = Mushroom.instance()
		add_child(new_mush)
		new_mush.position = map_to_world(mush_pos)
	
	for i in num_enemies:
		var new_enemy = Enemy.instance()
		add_child(new_enemy)
		var enemy_pos = map[randi() % map.size()]
		new_enemy.position = map_to_world(enemy_pos)
