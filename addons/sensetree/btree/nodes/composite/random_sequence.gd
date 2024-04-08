@tool
@icon("res://addons/sensetree/btree/icons/Random_Sequence.svg")
class_name SenseTreeRandomSequenceComposite
extends SenseTreeSequenceComposite

func _ready():
	randomize()
	
func reset():
	last_success_index = 0
	get_children().shuffle()
