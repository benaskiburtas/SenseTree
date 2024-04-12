@tool
class_name TreeVisualizerDeleteNodeButton
extends TreeVisualizerActionButton

const BUTTON_TEXT = "Delete Node"

func _init() -> void:
	super()
	text = BUTTON_TEXT

func _assign_button_state() -> void:
	if self.selected_node == null or _selected_node_group == null:
		disabled = true

func _assign_button_options() -> void:
	get_popup().clear(true)
	if self.selected_node == null or _selected_node_group == null:
		return
