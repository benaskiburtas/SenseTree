@tool
@icon("res://addons/sensetree/btree/icons/Decorator.svg")
class_name SenseTreeDecorator
extends SenseTreeNode

func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = super._get_configuration_warnings()
	
	var child_count = get_child_count()
	if child_count != 1:
		configuration_warnings.push_back(
			"Expected decorator node to have exactly one child, found %d children nodes instead." % child_count)
		
	return configuration_warnings
