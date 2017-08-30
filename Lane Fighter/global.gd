extends Node

var viewport = null
var viewport_scale
var viewport_res

func _ready():
	viewport = get_node("/root").get_children()[1].get_viewport_rect().size
	viewport_res = get_node("/root").get_children()[1].get_viewport_rect().size
	viewport_scale = 1080/viewport.y
	