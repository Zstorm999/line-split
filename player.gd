extends CharacterBody2D

@export var speed = 10000
@export var is_main = false

@export_category("other player")
@export var offset = Vector2.ZERO
@export var other: CharacterBody2D

func _process(delta: float) -> void:
	print("in main", is_main)
	if not is_main:
		_process_follow(delta)
	else:
		_process_main(delta)

func _process_main(delta: float):
	velocity = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized() * speed * delta
	
	#position = position + Vector2(1, 0.0)
	#velocity = Vector2(10, 0.0)
	
	move_and_slide()

func _process_follow(delta: float):
	position = other.position + offset
