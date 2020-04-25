extends KinematicBody2D

export var ACCELERATION =  300
export var MAX_SPEED = 50
export var FRICTION = 200

const EnenmyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

onready var animated_sprite = $AnimatedSprite
onready var stats = $Stats
onready var player_detection_zone = $PlayerDetectionZone
onready var hurt_box = $HurtBox

enum {
	IDLE,
	WANDER,
	CHASE
}
var knockback = Vector2.ZERO
var velocity =  Vector2.ZERO

var state = CHASE

func _ready():
	animated_sprite.frame = randi()%5
	animated_sprite.speed_scale = rand_range(0.7,1.3)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			animated_sprite.flip_h = velocity.x < 0
			seek_player()
	velocity = move_and_slide(velocity)
			
func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE
	else:
		state = IDLE
		

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 140
	hurt_box.create_hit_effet()

func _on_Stats_no_health():
	queue_free()
	var enemy_death_effect = EnenmyDeathEffect.instance()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position
