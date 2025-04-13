extends Area2D

func _ready() -> void:
	var game = get_tree().get_first_node_in_group("game") as Game
	
	if not game:
		print("There is no game")
		return
	
	game._on_end_initialized(self)
