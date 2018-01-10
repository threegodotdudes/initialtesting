extends CanvasLayer

var jumps_left
var text1
var text2

func _ready():
	get_node("jumps_left").set_pos(Vector2(0,0))
	set_fixed_process(true)

func _fixed_process(delta):
	jumps_left = get_owner().get_node("dummy").jumping
	text1 = "Jumps Left : %s" % jumps_left
	get_node("jumps_left").set_text(text1)
