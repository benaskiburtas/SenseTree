@tool
@icon("res://addons/sensetree/behavior_tree/icon/Leaf.svg")
class_name SenseTreeLeafNode
extends SenseTreeNode


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = []
	var child_count = get_child_count()
	if child_count:
		configuration_warnings.push_back(
			"Expected leaf node to not have child nodes, found %d child nodes" % child_count
		)
	return configuration_warnings


func get_sensenode_class() -> String:
	return "SenseTreeLeafNode"


func get_node_group() -> SenseTreeConstants.NodeGroup:
	return SenseTreeConstants.NodeGroup.LEAF
