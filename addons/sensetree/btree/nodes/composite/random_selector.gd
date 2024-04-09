@tool
@icon("res://addons/sensetree/btree/icons/Random_Selector.svg")
class_name SenseTreeRandomSelectorComposite
extends SenseTreeSelectorComposite


func _ready() -> void:
	randomize()


func reset() -> void:
	_last_running_index = 0
	get_children().shuffle()
