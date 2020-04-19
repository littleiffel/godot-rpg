extends Area2D

const hit_effet = preload("res://Effects/HitEffect.tscn")





func _on_HurtBox_area_entered(_area):
	var effect = hit_effet.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position
