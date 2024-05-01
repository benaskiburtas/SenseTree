@tool
class_name TreeVisualizeRenameNodeButton
extends TreeVisualizerNodeActionButton

signal rename_node_requested(node: TreeVisualizerGraphNode)

const BUTTON_TEXT = "Rename Node"


func _init() -> void:
	super()
	text = BUTTON_TEXT


func _assign_button_state() -> void:
	if self.selected_node == null:
		disabled = true
	else:
		disabled = false


func _assign_button_options() -> void:
	if self.selected_node == null:
		disabled = true
	else:
		disabled = false
