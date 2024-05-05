@tool
@icon("res://addons/sensetree/behavior_tree/icon/Random_Sequence.svg")
class_name SenseTreeRandomSequenceComposite
extends SenseTreeSequenceComposite


func _ready() -> void:
	randomize()


func reset() -> void:
	_last_success_index = 0
	shuffle_children_order()


func get_sensenode_class() -> String:
	return "SenseTreeRandomSequenceComposite"
