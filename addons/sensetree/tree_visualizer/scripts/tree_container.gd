@tool
class_name SenseTreeContainer
extends HBoxContainer

@onready var _graph_edit = $TreeGraphEditor
@onready var _tree_list_vertical_box = $TreeList/TreeListMarginContainer/TreeListVerticalBox


func _ready() -> void:
	_connect_message_bus_signals()
	_update_buttons()


func _connect_message_bus_signals() -> void:
	SenseTreeMessageBus.connect("tree_property_changed", _on_tree_property_changed)
	SenseTreeMessageBus.connect("tree_node_added", _on_tree_node_added)
	SenseTreeMessageBus.connect("tree_node_removed", _on_tree_node_removed)


func _on_tree_property_changed(node: Node, property_name: String) -> void:
	_update_buttons()


func _on_tree_node_added(node: Node, child_node: Node) -> void:
	_update_buttons()


func _on_tree_node_removed(node: Node, child_node: Node) -> void:
	_update_buttons()


func _update_buttons() -> void:
	_clear_ui()
	_populate_buttons()


func _clear_ui() -> void:
	for child in _graph_edit.get_children():
		child.queue_free()
	for child in _tree_list_vertical_box.get_children():
		child.queue_free()


func _populate_buttons() -> void:
	var scene: Node
	if Engine.is_editor_hint():
		scene = get_tree().edited_scene_root
	else:
		scene = get_tree().current_scene

	for sense_node in _find_all_sense_nodes(scene):
		var button = Button.new()
		button.text = sense_node.name
		_tree_list_vertical_box.add_child(button)


func _find_all_sense_nodes(node) -> Array:
	var result = []
	if node is SenseTreeNode:
		result.append(node)

	if node:
		for child in node.get_children():
			result.append_array(_find_all_sense_nodes(child))

	return result
