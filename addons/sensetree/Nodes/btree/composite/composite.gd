@tool
@icon("../../../icons/placeholder.svg")
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
	