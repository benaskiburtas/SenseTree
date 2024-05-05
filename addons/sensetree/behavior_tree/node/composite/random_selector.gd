@tool
@icon("res://addons/sensetree/behavior_tree/icon/Random_Selector.svg")
class_name SenseTreeRandomSelectorComposite
extends SenseTreeSelectorComposite


func _ready() -> void:
	randomize()


func reset() -> void:
	_last_running_index = 0
	shuffle_children_order()


func get_sensenode_class() -> String:
	return "SenseTreeRandomSelectorComposite"
