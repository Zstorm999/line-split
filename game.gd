class_name Game
extends Node2D

@export var levels: Array[PackedScene] = []
@export var level_idx = 0

@onready var player1 = $GlobalCamera/Viewport1/Player1
@onready var player2 = $GlobalCamera/Viewport1/Player2
@onready var viewport1 = $GlobalCamera/Viewport1

var load_new = true
var loading = false
var reload_selectors = false

var registered_end = null

var seconds = 0

func _ready() -> void:
	_load_new_level()

func _process(delta: float) -> void:
	if reload_selectors:
		$GlobalCamera._register_signals()
		reload_selectors = false
	
	if load_new:
		_load_new_level()
		$GlobalCamera/Line2D.visible = false
		reload_selectors = true


func _on_level_end_reached(player, end_node):
	if (player.global_position - end_node.global_position).length() > 32:
		print("where am i")
		return
	
	if loading or end_node != registered_end:
		print("called while loading")
		return
	
	if not player.is_main:
		return
	
	if level_idx + 1 == levels.size():
		get_tree().change_scene_to_file("res://title_screen.tscn")
		return
	
	level_idx += 1
	load_new = true

func _on_start_initialized(start: Node2D):
	player1.global_position = start.global_position
	player2.is_main = false
	player1.is_main = true
	loading = false

func _on_end_initialized(end: Area2D):
	end.body_entered.connect(_on_level_end_reached.bind(end))
	registered_end = end

func _load_new_level():
	loading = true
	var level = get_tree().get_first_node_in_group("Level")
	if level:
		viewport1.remove_child(level)
		level.queue_free()
	
	var new_level_packed = levels[level_idx]
	var new_level = new_level_packed.instantiate()
	viewport1.add_child(new_level)
	load_new = false


func _on_timer_timeout() -> void:
	seconds += 1
