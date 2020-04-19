extends Area2D

export(bool) var  show_hit = true

const hit_effet = preload("res://Effects/HitEffect.tscn")

func _on_HurtBox_area_entered(_area):
	if show_hit:
		var effect = hit_effet.instance()
		var main = get_tree().current_scene
		main.add_child(effect)
		effect.global_position = global_position
