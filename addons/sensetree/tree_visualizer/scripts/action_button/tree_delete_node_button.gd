@tool
class_name TreeVisualizerDeleteNodeButton
extends TreeVisualizerActionButton

const BUTTON_TEXT = "Delete Node"

func _init() -> void:
	super()
	text = BUTTON_TEXT

func _assign_button_state() -> void:
	var sense_node = _selected_node.scene_node
	var node_group = sense_node.get_node_group()

func _assign_button_options() -> void:
	pass
