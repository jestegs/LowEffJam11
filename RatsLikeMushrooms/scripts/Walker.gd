extends Node
class_name Walker # allows this class to be used without preloading

# adapted from heartbeasts tutorial on youtube, accessed 5/4/2021
var DIRECTIONS = [
	Vector2.UP,
	Vector2.RIGHT,
	Vector2.DOWN,
	Vector2.LEFT
]

var position:Vector2
var direction = DIRECTIONS[randi() % 4]
var level_area:Rect2
var step_history:Array
var direction_history:Array
var steps_since_turn = 0 # limit size of hallways
var chng_direction_chance = 0.25


func _init(start_pos:Vector2, _level_area:Rect2):
	assert(_level_area.has_point(start_pos))
	position = start_pos
	step_history.append(start_pos)
	self.level_area = _level_area


func walk(steps, step_limit=4):
	var step_count = 0
	while step_count < steps-1:
		# 25% to change direction, or if step limit reached
		if randf() <= chng_direction_chance or steps_since_turn >= step_limit:
			if not change_direction(): step_count -= 1
		
		if step():
			# if we can take a step...
			step_history.append(position)
			step_count += 1
		else:
			if not change_direction(): step_count -= 1
	
	return step_history


func step():
	var target_pos = position + direction
	
	if is_valid_point(target_pos):
		steps_since_turn += 1
		position = target_pos
		return true
	else:
		return false


func change_direction():
	# changing direction, reset steps since turn
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction) # don't move in previous direction
	
	# get random direction
	directions.shuffle()
	direction = directions.pop_front()
	
	# while the direction is invalid, get the next direction
	while not is_valid_point(position + direction):
		direction = directions.pop_front()
		
		# backtracking:
		# if there is no valid direction, remove path from history
		# and go back a step
		if direction == null:
			step_history.pop_front()
			direction_history.pop_front()
			position = step_history.front()
			direction = direction_history.front()
			return false
	
	direction_history.append(direction)
	return true


func is_valid_point(point:Vector2):
	# out of bounds (oob) - probably don't need this because of the sub area
	if not level_area.has_point(point):
		return false
	
	# on edge of area
	var sub_area = Rect2(
		level_area.position + Vector2.ONE, 
		level_area.size - Vector2(2, 2)
	)
	if not sub_area.has_point(point):
		return false
		
	# overlap
	for step in step_history:
		if step == point:
			return false
	
	return true
