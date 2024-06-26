@tool
@icon("res://addons/sensetree/behavior_tree/icon/Decorator.svg")
class_name SenseTreeDecorator
extends SenseTreeNode


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = super._get_configuration_warnings()

	var child_count = get_child_count()
	if child_count != 1:
		configuration_warnings.push_back(
			"Decorator node should have exactly one child, found %d children instead." % child_count
		)

	return configuration_warnings


func get_sensenode_class() -> String:
	return "SenseTreeDecorator"


func get_node_group() -> SenseTreeConstants.NodeGroup:
	return SenseTreeConstants.NodeGroup.DECORATOR
