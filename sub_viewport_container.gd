extends SubViewportContainer

func _input(event: InputEvent) -> void:
	$Viewport1.handle_input_locally = true
