@tool
@icon("res://addons/sensetree/behavior_tree/icon/Composite.svg")
class_name SenseTreeCompositeNode
extends SenseTreeNode

func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = super._get_configuration_warnings()
	
	var child_count = get_child_count()
	if child_count == 0:
		configuration_warnings.push_back(
			"Composite-type nodes should have at least a single child node.")
	elif child_count == 1:
		configuration_warnings.push_back(
			"Composite-type node only has a single child,
			reconsider if parent composite node is necessary.")

	return configuration_warnings


func get_sensenode_class() -> String:
	return "SenseTreeCompositeNode"


func get_node_group() -> SenseTreeConstants.NodeGroup:
	return SenseTreeConstants.NodeGroup.COMPOSITE


func shuffle_children_order() -> void:
	var order_array = []
	var children_count = get_child_count()

	for i in range(children_count):
		order_array.push_back(i)
	order_array.shuffle()

	for i in range(children_count):
		var child = get_child(i)
		move_child(child, order_array[i])
