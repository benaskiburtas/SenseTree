@tool
class_name TreeVisualizerActionButton
extends MenuButton

var selected_node: TreeVisualizerGraphNode = null:
	set(new_node):
		if new_node != null:
			selected_node = new_node
			_selected_node_group = new_node.scene_node.get_node_group()
		else:
			selected_node = null
			_selected_node_group = null
		_assign_button_state()
		_assign_button_options()

var _selected_node_group

func _init():
	add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	disabled = true

func _assign_button_state() -> void:
	pass

func _assign_button_options() -> void:
	pass
	
