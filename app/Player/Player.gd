extends KinematicBody2D

export var ACCELERATION = 400
export var MAX_SPEED = 60
export var FRICTION = 500 
export var ROLL_SPEED = 100
enum {
	MOVE, 
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sword_hitbox = $HitBoxPivot/SwordHitBox

func _ready():
	animation_tree.active = true
	sword_hitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move(delta)
		ROLL:
			roll(delta)
		ATTACK:
			attack(delta)
	
# warning-ignore:unused_argument
func attack(delta):
	velocity = Vector2.ZERO
	animation_state.travel("Attack")
	
func move(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hitbox.knockback_vector = input_vector
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_update()
	if Input.is_action_just_pressed("roll"):
		state = ROLL
		 
	if Input.is_action_just_pressed("attack"):
		state = ATTACK 
	
# warning-ignore:unused_argument
func roll(delta):
	velocity = roll_vector * ROLL_SPEED
	animation_state.travel("Roll")
	move_and_update()

func move_and_update():
	velocity = move_and_slide(velocity)
	
func roll_animation_finished():
	state = MOVE
	
func attack_animation_finished():
	state = MOVE
