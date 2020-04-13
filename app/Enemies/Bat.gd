extends KinematicBody2D

var knockback = Vector2.ZERO

onready var animated_sprite = $AnimatedSprite
onready var stats = $Stats

func _ready():
	animated_sprite.frame = randi()%5
	animated_sprite.speed_scale = rand_range(0.7,1.3)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 140

func _on_Stats_no_health():
	queue_free()
