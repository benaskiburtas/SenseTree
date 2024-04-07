@tool
@icon("../../icons/placeholder.svg")
class_name SenseTreeNode
extends Node

enum Status { SUCCESS, FAILURE, RUNNING }

func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = []
	for child_node in get_children():
		if not (child_node is SenseTreeNode):
			configuration_warnings.push_back(
				"All child nodes should be of SenseTreeNode type,
				found node of type %s."
				% typeof(child_node))
	return configuration_warnings

func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	return Status.SUCCESS
	
func stop(actor: Node, blackboard: SenseTreeBlackboard) -> void:
	pass
