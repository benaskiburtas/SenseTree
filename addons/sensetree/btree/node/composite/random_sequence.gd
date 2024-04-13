@tool
@icon("res://addons/sensetree/btree/icon/Random_Sequence.svg")
class_name SenseTreeRandomSequenceComposite
extends SenseTreeSequenceComposite


func _ready() -> void:
	randomize()


func reset() -> void:
	_last_success_index = 0
	get_children().shuffle()


func get_sensenode_class() -> String:
	return "SenseTreeRandomSequenceComposite"
