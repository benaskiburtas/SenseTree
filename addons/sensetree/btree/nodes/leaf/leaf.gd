@tool
@icon("res://addons/sensetree/btree/icons/Leaf.svg")
class_name SenseTreeLeafNode
extends SenseTreeNode

func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = []
	var child_count = get_child_count();
	if child_count:
		configuration_warnings.push_back(
			"Expected leaf node to not have child nodes, found %d child nodes" % child_count)
	return configuration_warnings
