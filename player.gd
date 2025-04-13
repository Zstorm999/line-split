extends CharacterBody2D

@export var speed = 7000
@export var is_main = false

@export_category("other player")
@export var offset = Vector2.ZERO
@export var other: CharacterBody2D

enum Direction {UP, DOWN, LEFT, RIGHT, NOTSET}

var direction = Direction.NOTSET

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not is_main:
		_process_follow(delta)
	else:
		_process_main(delta)

func _process_main(delta: float):
	velocity = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized() * speed * delta
	
	if velocity.is_zero_approx():
		direction = Direction.NOTSET
		other.direction = Direction.NOTSET
		$AnimatedSprite2D.stop()
		other.get_child(0).stop()
	elif Input.get_action_strength("move_down"):
		if direction != Direction.DOWN:
			_set_anim_state("Down", Direction.DOWN)
	elif Input.get_action_strength("move_up"):
		if direction != Direction.UP:
			_set_anim_state("Up", Direction.UP)
	elif Input.get_action_strength("move_right"):
		if direction != Direction.RIGHT:
			_set_anim_state("LR", Direction.RIGHT)
			$AnimatedSprite2D.flip_h = false
			other.get_child(0).flip_h = false
	elif Input.get_action_strength("move_left"):
		if direction != Direction.LEFT:
			_set_anim_state("LR", Direction.LEFT)
			$AnimatedSprite2D.flip_h = true
			other.get_child(0).flip_h = true
	
	move_and_slide()

func _process_follow(delta: float):
	position = other.position + offset

func _set_anim_state(anim, dir):
	direction = dir
	other.direction = dir
	$AnimatedSprite2D.play(anim)
	other.get_child(0).play(anim)
