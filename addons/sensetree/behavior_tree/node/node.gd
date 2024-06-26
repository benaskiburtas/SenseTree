@tool
@icon("res://addons/sensetree/behavior_tree/icon/Node.svg")
class_name SenseTreeNode
extends Node

enum Status { SUCCESS, FAILURE, RUNNING }


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = []
	for child_node in get_children():
		if not (child_node is SenseTreeNode):
			configuration_warnings.push_back("Child nodes should be of SenseTreeNode type.")
		if child_node is SenseTree:
			configuration_warnings.push_back("Behavior trees should not be nested.")
	return configuration_warnings


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> SenseTreeNode.Status:
	return Status.SUCCESS


func get_sensenode_class() -> String:
	return "SenseTreeNode"


func get_node_group() -> SenseTreeConstants.NodeGroup:
	return SenseTreeConstants.NodeGroup.UNKNOWN


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	return []


func has_children() -> bool:
	return get_child_count() != 0
