@tool
@icon("res://addons/sensetree/behavior_tree/icon/Tree.svg")
class_name SenseTreeAgent
extends Node

@export var sensetree_resource: PackedScene:
	set(new_resource):
		sensetree_resource = new_resource
		_initialize_resource()

var _tree_instance: Node
var _property_dependencies: Array[PropertyDependency]

func _get(property: StringName) -> Variant:
	print(property)
	var path = property.split("_")
	if path.size() == 2:
		var node_name = path[0]
		var property_name = path[1]
		for dependency in _property_dependencies:
			if dependency.node_name == node_name and dependency.property["name"] == property_name:
				var target_node = get_node(dependency.node_path)
				if target_node:
					return target_node.get(property_name)
	return null


func _set(property: StringName, value: Variant) -> bool:
	var path = property.split("_")
	if path.size() == 2:
		var node_name = path[0]
		var property_name = path[1]
		for dependency in _property_dependencies:
			if dependency.node_name == node_name and dependency.property["name"] == property_name:
				var target_node = get_node(dependency.node_path)
				if target_node:
					target_node.set(property_name, value)
					return true
		return false
	return false

func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = []
	if sensetree_resource == null:
		configuration_warnings.push_back("SenseTree resource should be assigned.")
	return configuration_warnings


func _initialize_resource() -> void:
	_tree_instance = sensetree_resource.instantiate()
	add_child(_tree_instance)
	_explore_properties(_tree_instance)


func _explore_properties(root: Node):
	var stack = []
	stack.push_back(root)

	while not stack.is_empty():
		var node = stack.pop_front()

		# Verify node type
		if not node is SenseTreeNode:
			push_error(
				"SenseTreeAgent Error: All SenseTree resource nodes must be of type SenseTreeNode."
			)
			_property_dependencies.clear()
			return

		# Collect property dependencies
		print(node)
		for property in node.get_property_list():
			if "usage" in property and property["usage"] == PROPERTY_USAGE_SCRIPT_VARIABLE:
				print(property)
				var new_dependency = PropertyDependency.new(
					node.name, node.get_path(), property.name, null
				)
				_property_dependencies.push_back(new_dependency)

		# Prepare children nodes for exploration
		var node_children = node.get_children().duplicate(true)
		node_children.reverse()
		for child in node_children:
			stack.push_back(child)


class PropertyDependency:
	var node_name: String
	var node_path: String
	var property: Dictionary
	var property_value: Variant

	func _init(
		node_name: String, node_path: String, property: Dictionary, property_value: Variant
	) -> void:
		self.node_name = node_name
		self.node_path = node_path
		self.property = property
		self.property_value = property_value
