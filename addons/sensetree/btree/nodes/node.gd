@tool
@icon("res://addons/sensetree/btree/icons/Node.svg")
class_name SenseTreeNode
extends Node

enum Status { SUCCESS, FAILURE, RUNNING }

func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = []
	for child_node in get_children():
		if not (child_node is SenseTreeNode):
			configuration_warnings.push_back(
				"Child nodes should be of SenseTreeNode type,
				found node of type %s."
				% child_node.get_class())
		if child_node is SenseTree:
			configuration_warnings.push_back(
				"Behavior trees should not be nested.")
	return configuration_warnings

func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	return Status.SUCCESS
	
func stop(actor: Node, blackboard: SenseTreeBlackboard) -> void:
	pass
