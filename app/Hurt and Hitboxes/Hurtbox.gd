extends Area2D

signal invincibility_started
signal invincibility_ended

const hit_effet = preload("res://Effects/HitEffect.tscn")

onready var timer = $Timer

var invincible = false setget set_invincible

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invicibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effet():
	var effect = hit_effet.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_Timer_timeout():
	self.invincible = false


func _on_HurtBox_invincibility_ended():
	monitorable = true


func _on_HurtBox_invincibility_started():
	set_deferred("monitorable", false)
