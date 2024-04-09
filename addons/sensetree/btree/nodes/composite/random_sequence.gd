@tool
@icon("res://addons/sensetree/btree/icons/Random_Sequence.svg")
class_name SenseTreeRandomSequenceComposite
extends SenseTreeSequenceComposite


func _ready() -> void:
	randomize()


func reset() -> void:
	_last_success_index = 0
	get_children().shuffle()
