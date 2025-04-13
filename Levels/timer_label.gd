extends Label

func _ready() -> void:
	var time = get_tree().root.get_child(0).seconds
	
	var minutes = int(time / 60)
	var seconds = time % 60
	
	text = "%02d : %02d" % [minutes, seconds]
