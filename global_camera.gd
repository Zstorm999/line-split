extends Node2D

var initialized = false
var is_inside = false
var inside_selector: Area2D = null

var dragging = false

const LEFT_BOUND = -595
const RIGHT_BOUND = 550
const TOP_BOUND = -325
const BOTTOM_BOUND = 325

var TD_ANGLE = Vector2(LEFT_BOUND, TOP_BOUND).angle_to(Vector2(RIGHT_BOUND, TOP_BOUND))
var LR_ANGLE = PI - TD_ANGLE

var line_world = [Vector2.ZERO, Vector2.ZERO]

@onready var line = $Line2D

@onready var player1 = $Viewport1/Player1
@onready var player2 = $Viewport1/Player2

@onready var viewport1 = $Viewport1
@onready var viewport2 = $Viewport2
@onready var output = $TextureRect
@onready var fake_pointer = $Viewport1/FakePointer

var selectors =  []

var viewport_base_height = ProjectSettings.get_setting("display/window/size/viewport_height")

func _ready() -> void:
	_on_size_changed()
	
	viewport2.world_2d = viewport1.world_2d
	
	get_viewport().size_changed.connect(_on_size_changed)
	output.material.set_shader_parameter("viewport1", viewport1.get_texture())
	output.material.set_shader_parameter("viewport2", viewport2.get_texture())
	output.material.set_shader_parameter("visible", false);

func _unhandled_input(event):
	viewport1.push_input(event)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_handle_left_click()
			else:
				_handle_left_release()
	if event is InputEventMouseMotion:
		if dragging:
			line.set_point_position(1, get_global_mouse_position())
		


func _process(delta: float) -> void:
	if not initialized:
		_register_signals()
		initialized = true
	
	if line.visible:
		var vp_size = get_viewport().get_visible_rect().size
		line.set_point_position(0, viewport1_to_world(line_world[0]))
		output.material.set_shader_parameter("line_0", line.points[0] / vp_size)
		if not dragging:
			output.material.set_shader_parameter("visible", true);
			line.set_point_position(1, viewport1_to_world(line_world[1]))
			output.material.set_shader_parameter("line_1",  line.points[1] / vp_size)
		
		var player_pos: Vector2 = viewport1_to_world(player1.position) - line.points[0]
		var direction: Vector2 = line.points[1] - line.points[0]
		
		if direction.cross(player_pos) > 0:
			player1.is_main = false
			player2.is_main = true
			$AudioStreamPlayer.set
			$AudioStreamPlayer.bus = "Distorted"
		else:
			player2.is_main = false
			player1.is_main = true
			$AudioStreamPlayer.bus = "Master"
	else:
		output.material.set_shader_parameter("visible", false);
	

func _register_signals() -> void:
	var new_selectors = get_tree().get_nodes_in_group("selectors")
	print("registering selectors: ", new_selectors)
	for s_raw in new_selectors:
		var s = s_raw as Area2D
		if not s:
			continue
		selectors.append(s)
		s.area_entered.connect(on_selector_enter.bind(s))
		s.area_exited.connect(on_selector_exit.bind(s))
		#s.mouse_exited.connect(on_selector_exit.bind(s))

func _handle_left_click():
	if not is_inside:
		return
	# immediatly disable shader output
	output.material.set_shader_parameter("visible", bool(false));
	
	line_world[0] = inside_selector.global_position
	line.set_point_position(1, get_global_mouse_position())
	line.visible = true
	dragging = true

func _handle_left_release():
	if  not is_inside:
		if dragging:
			line.visible = false
		return
	dragging = false

	var line_vec = inside_selector.global_position - line_world[0]
	var angle = line_vec.angle()
	var target = _find_target(angle)
	
	var projected = line_vec.normalized() * target.length()
	
	line_world[1] =  projected + line_world[0]
	line_world[0] = -projected + line_world[0]


func _find_target(angle) -> Vector2:
	if angle > 0.0:
		if angle <= PI / 2:
			return Vector2(LEFT_BOUND, TOP_BOUND)
		else:
			return Vector2(RIGHT_BOUND, TOP_BOUND)
	else:
		if angle >= -PI/2:
			return Vector2(LEFT_BOUND, BOTTOM_BOUND)
		else:
			return Vector2(RIGHT_BOUND, BOTTOM_BOUND)

func _on_size_changed():
	var screen_size = get_viewport().get_visible_rect().size
	
	output.size = screen_size
	viewport1.size = screen_size
	viewport2.size = screen_size
	output.material.set_shader_parameter("viewport_size", screen_size)

func on_selector_enter(_area, s) -> void:
	is_inside = true
	inside_selector = s

func on_selector_exit(_area, s) -> void:
	is_inside = false


func viewport1_to_world(position: Vector2) -> Vector2:
	return viewport1.canvas_transform * position
