@tool
@icon("../../../icons/random_selector.svg")
class_name SenseTreeRandomSelectorComposite
extends SenseTreeSelectorComposite

func _ready():
	randomize()
	
func reset():
	last_running_index = 0
	get_children().shuffle()
