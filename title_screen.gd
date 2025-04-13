extends Node2D

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	$CanvasLayer/MainMenu.visible = false
	$CanvasLayer/Credits.visible = true
	

func _on_back_button_pressed() -> void:
	$CanvasLayer/Credits.visible = false
	$CanvasLayer/MainMenu.visible = true
