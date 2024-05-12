@tool
@icon("res://addons/sensetree/behavior_tree/icon/Tree.svg")
class_name SenseTreeAgent
extends Node

@export var sensetree_resource: PackedScene:
	set(new_resource):
		if not new_resource:
			if _tree_instance:
				_tree_instance.free()
			_tree_instance = null
		else:
			sensetree_resource = new_resource
			_initialize_resource()

var _tree_instance: Node
var _property_dependencies: Array[PropertyDependency]


#func _get(property: StringName) -> Variant:
	#print(property)
	#var path = property.split("_")
	#if path.size() == 2:
		#var node_name = path[0]
		#var property_name = path[1]
		#for dependency in _property_dependencies:
			#if dependency.node_name == node_name and dependency.property["name"] == property_name:
				#var target_node = get_node(dependency.node_path)
				#if target_node:
					#return target_node.get(property_name)
	#return null
#
#
#func _set(property: StringName, value: Variant) -> bool:
	#print(property)
	#notify_property_list_changed()
	#var path = property.split("_")
	#if path.size() == 2:
		#var node_name = path[0]
		#var property_name = path[1]
		#for dependency in _property_dependencies:
			#if dependency.node_name == node_name and dependency.property["name"] == property_name:
				#var target_node = get_node(dependency.node_path)
				#if target_node:
					#target_node.set(property_name, value)
					#return true
		#return false
	#return false


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = []
	if sensetree_resource == null:
		configuration_warnings.push_back("SenseTree resource should be assigned.")
	return configuration_warnings


func _get_property_list() -> Array:
	var property_array: Array = []
	var current_node_name: String = ""
	var current_node_group: Variant = null  # Usually will be a dictionary

	for property in _property_dependencies:
		# Check for a new node (start of a group)
		if property.node_name != current_node_name:
			current_node_name = property.node_name
			current_node_group = {
				"name": current_node_name,
				"type": TYPE_NIL,
				"usage": PROPERTY_USAGE_GROUP,
				"hint_string": property.node_path,
			}
			property_array.append(current_node_group)

		# Add dependency property details to group
		var dependency = {
			"name": property.property_name,
			"class_name": property.property_class_name,
			"type": property.property_type,
			"hint": property.property_hint,
			"hint_string": property.property_hint_string,
			"usage": property.property_usage
		}
		property_array.append(dependency)

	return property_array


func _initialize_resource() -> void:
	if not sensetree_resource:
		push_warning("SenseTreeAgent Error: SenseTree resource is unassigned.")
		return

	if not sensetree_resource is PackedScene:
		push_warning("SenseTreeAgent Error: Assigned resource is not a PackedScene.")
		return

	if not sensetree_resource.can_instantiate():
		push_warning(
			"SenseTreeAgent Error: Assigned PackedScene resource cannot be instantiated, is it empty?"
		)
		return

	var resource_instance = sensetree_resource.instantiate()
	if not resource_instance is SenseTree:
		push_warning(
			"SenseTreeAgent Error: Assigned SenseTree resource does not contain SenseTree as root."
		)
		return

	# Proceed with property traversal
	_tree_instance = resource_instance
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
		var sense_node = node as SenseTreeNode

		# Collect property dependencies
		for property in sense_node.get_property_list():
			print(property.keys())
			if "usage" in property and property["usage"] == 4102:
				var new_dependency = PropertyDependency.new(
					sense_node.name,
					"",  # ADD PATH
					property["name"] if "name" in property else "",
					property["class_name"] if "class_name" in property else "",
					property["type"] if "type" in property else 0,
					property["hint"] if "hint" in property else PropertyHint.PROPERTY_HINT_NONE,
					property["hint_string"] if "hint_string" in property else StringName(),
					(
						property["property_usage"]
						if "property_usage" in property
						else PropertyUsageFlags.PROPERTY_USAGE_EDITOR
					),
					null
				)
				_property_dependencies.push_back(new_dependency)

		# Prepare children nodes for exploration
		var node_children = sense_node.get_children()
		for child in node_children:
			stack.push_back(child)
	pass


## Holds metadata about a specific exportable property.
class PropertyDependency:
	## Corresponds to the 'name' property of a node.
	var node_name: String
	## Corresponds to the 'get_path()' value of a node.
	var node_path: String

	## Corresponds to 'name' in the property dictionary.
	var property_name: String
	## Corresponds to 'class_name' in the property dictionary.
	var property_class_name: String
	## Corresponds to 'type' in the property dictionary.
	var property_type: int
	## Corresponds to 'hint' in the property dictionary.
	var property_hint: PropertyHint
	## Corresponds to 'hint_string' in the property dictionary.
	var property_hint_string: String
	## Corresponds to 'usage' in the property dictionary.
	var property_usage: PropertyUsageFlags
	## Corresponds to the property value on the node.
	var property_value: Variant

	func _init(
		node_name: String,
		node_path: String,
		property_name: String,
		property_class_name: StringName,
		property_type: int,
		property_hint: PropertyHint,
		property_hint_string: String,
		property_usage: PropertyUsageFlags,
		property_value: Variant
	) -> void:
		self.node_name = node_name
		self.node_path = node_path
		self.property_name = property_name
		self.property_class_name = property_class_name
		self.property_type = property_type
		self.property_hint = property_hint
		self.property_hint_string = property_hint_string
		self.property_usage = property_usage
		self.property_value = property_value
