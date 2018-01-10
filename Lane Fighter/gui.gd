extends CanvasLayer

var jumps_left
var text1
var text2

func _ready():
	get_node("Stamina").set_pos(Vector2(10,10))
	get_node("Resource1_outline").set_pos(Vector2(get_node("Stamina").get_size().x + 15 ,10))
	#get_node("Resource1").edit_set_pivot(Vector2(0,0))
	set_fixed_process(true)

func _fixed_process(delta):
	get_node("Stamina").set_text("Stamina")
