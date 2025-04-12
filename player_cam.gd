extends Camera2D

@onready var player: Node2D

func _process(delta: float) -> void:
	position = player.position
