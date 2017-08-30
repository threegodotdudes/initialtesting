extends CanvasLayer

var jumps_left
var boost_condition
var text1
var text2

func _ready():
	get_node("jumps_left").set_pos(Vector2(0,0))
	get_node("boost_condition").set_pos(Vector2(0,get_node("jumps_left").get_rect().size.y))
	set_fixed_process(true)

func _fixed_process(delta):
	jumps_left = get_owner().get_node("dummy").jumping
	text1 = "Jumps Left : %s" % jumps_left
	get_node("jumps_left").set_text(text1)
	if Input.is_action_pressed("boost"):
		get_node("boost_condition").set_text("Boost ON")
	else:
		get_node("boost_condition").set_text("Boost OFF")
		
	