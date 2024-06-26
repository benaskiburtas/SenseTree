@tool
class_name TreeVisualizerNodeActionButton
extends MenuButton

var selected_node: TreeVisualizerGraphNode = null:
	set(new_node):
		if new_node != null:
			selected_node = new_node
			_selected_node_group = new_node.sensetree_node.get_node_group()
		else:
			selected_node = null
		_assign_button_state()
		_assign_button_options()

var _selected_node_group: SenseTreeConstants.NodeGroup = SenseTreeConstants.NodeGroup.UNKNOWN


func _init() -> void:
	flat = false
	disabled = true


func _assign_button_state() -> void:
	pass


func _assign_button_options() -> void:
	pass
