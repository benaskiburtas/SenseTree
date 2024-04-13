@tool
@icon("res://addons/sensetree/btree/icon/Node.svg")
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


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	return Status.SUCCESS


func stop(actor: Node, blackboard: SenseTreeBlackboard) -> void:
	pass


func get_sensenode_class() -> String:
	return "SenseTreeNode"


func get_node_group():
	return SenseTreeConstants.NodeGroup.UNKNOWN


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	return []


func has_children() -> bool:
	return has_children()
