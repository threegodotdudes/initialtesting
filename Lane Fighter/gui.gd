extends CanvasLayer

func _ready():
	get_node("Resource1_label").set_text("Stamina")
	get_node("Resource1_label").set_pos(Vector2(10,10))
	get_node("Resource1_outline").set_pos(Vector2(get_node("Resource1_label").get_size().x + 20 ,10))
	#get_node("Resource1").edit_set_pivot(Vector2(0,0))
	set_fixed_process(true)

