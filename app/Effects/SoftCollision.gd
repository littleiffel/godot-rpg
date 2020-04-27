extends Area2D


func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0
	
func get_push_back_vector():
	var areas = get_overlapping_areas()
	var push_back_vector: Vector2 = Vector2.ZERO
	if is_colliding():
		var area = areas[0]
		push_back_vector = area.global_position.direction_to(global_position)
		push_back_vector = push_back_vector.normalized()
	
	return push_back_vector
