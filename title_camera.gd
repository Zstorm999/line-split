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
	output.material.set_shader_parameter("visible", true);
	
	
	var vp_size = get_viewport().get_visible_rect().size
	#line.set_point_position(0, viewport1_to_world(line_world[0]))
	output.material.set_shader_parameter("line_0", line.points[0] / vp_size)
	#line.set_point_position(1, viewport1_to_world(line_world[1]))
	output.material.set_shader_parameter("line_1",  line.points[1] / vp_size)


func _on_size_changed():
	var screen_size = get_viewport().get_visible_rect().size
	
	output.size = screen_size
	viewport1.size = screen_size
	viewport2.size = screen_size
	output.material.set_shader_parameter("viewport_size", screen_size)

func viewport1_to_world(position: Vector2) -> Vector2:
	return viewport1.canvas_transform * position
