@tool
@icon("res://addons/sensetree/btree/icons/Node.svg")
class_name SenseTreeNode
extends Node

enum Status { SUCCESS, FAILURE, RUNNING }

const MESSAGE_BUS_NODE_PATH: String = "/root/SenseTreeMessageBus"

func _set(property, value) -> bool:
	if property in self:
		set(property, value)
		get_node(MESSAGE_BUS_NODE_PATH).emit_signal("tree_property_changed", self, property)
		return true
	else:
		return false

func add_child(node: Node, force_readable_name: bool = false, internal: InternalMode = 0) -> void:
	add_child(node, force_readable_name, internal)
	get_node(MESSAGE_BUS_NODE_PATH).emit_signal("tree_node_added", self, node)

func remove_child(node: Node) -> void:
	get_node(MESSAGE_BUS_NODE_PATH).emit_signal("tree_node_removed", self, node) 
	remove_child(node)


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
