extends Area2D

func _process(delta: float) -> void:
	#print(get_viewport().get_mouse_position())
	global_position = get_global_mouse_position()
