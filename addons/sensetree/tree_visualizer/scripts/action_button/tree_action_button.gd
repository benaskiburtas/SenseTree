@tool
class_name TreeVisualizerActionButton
extends OptionButton

var _selected_node: TreeVisualizerGraphNode = null:
	set(new_node):
		if new_node != null:
			_selected_node = new_node
			_selected_node_group = new_node.scene_node.get_node_group()
		else:
			_selected_node = null
			_selected_node_group = null
		_assign_button_state()
		_assign_button_options()


var _selected_node_group

func _init():
	add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	disabled = true

func set_selected(selected_node: TreeVisualizerGraphNode) -> void:
	_selected_node = selected_node

func _assign_button_state() -> void:
	pass

func _assign_button_options() -> void:
	pass
	
