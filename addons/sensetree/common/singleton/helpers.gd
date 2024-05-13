@tool
extends Node

var _sense_tree_class_regex: RegEx = RegEx.create_from_string(
	SenseTreeConstants.PLUGIN_NODE_CLASS_PREFIX
)

var _native_nodes_path_pattern: RegEx = RegEx.create_from_string(
	SenseTreeConstants.NATIIVE_NODE_PATH_PATTERN
)
var _example_nodes_path_pattern: RegEx = RegEx.create_from_string(
	SenseTreeConstants.EXAMPLE_NODE_PATH_PATTERN
)
var _custom_nodes_path_pattern: RegEx = RegEx.create_from_string(
	SenseTreeConstants.CUSTOM_NODE_PATH_PATTERN
)

var _sense_tree_classes: Dictionary
var _sense_tree_composites: Array[Dictionary]
var _sense_tree_decorators: Array[Dictionary]
var _sense_tree_leaves: Array[Dictionary]

var _sense_native_tree_leaves: Array[Dictionary]
var _sense_example_tree_leaves: Array[Dictionary]
var _sense_custom_tree_leaves: Array[Dictionary]


func _ready() -> void:
	_form_sense_node_class_caches()


func get_class_definitions_by_group(node_group: SenseTreeConstants.NodeGroup) -> Array[Dictionary]:
	match node_group:
		SenseTreeConstants.NodeGroup.COMPOSITE:
			return _sense_tree_composites
		SenseTreeConstants.NodeGroup.DECORATOR:
			return _sense_tree_decorators
		SenseTreeConstants.NodeGroup.LEAF:
			return _sense_tree_leaves
		_:
			return []


func get_leaf_definitions_by_source_type(
	source_type: SenseTreeConstants.NodeSourceType
) -> Array[Dictionary]:
	match source_type:
		SenseTreeConstants.NodeSourceType.NATIVE:
			return _sense_native_tree_leaves
		SenseTreeConstants.NodeSourceType.EXAMPLE:
			return _sense_example_tree_leaves
		SenseTreeConstants.NodeSourceType.CUSTOM:
			return _sense_custom_tree_leaves
		_:
			return []


func try_acquire_icon_path(sense_tree_class: String) -> String:
	if sense_tree_class in _sense_tree_classes:
		var class_definition = _sense_tree_classes[sense_tree_class]
		if "icon" in class_definition:
			return class_definition["icon"]
	return String()


func try_acquire_script_path(sense_tree_class: String) -> String:
	if sense_tree_class in _sense_tree_classes:
		var class_definition = _sense_tree_classes[sense_tree_class]
		if "path" in class_definition:
			return class_definition["path"]
	return String()


static func set_container_margins(container: Container, margin: int) -> void:
	container.add_theme_constant_override("margin_top", margin)
	container.add_theme_constant_override("margin_left", margin)
	container.add_theme_constant_override("margin_bottom", margin)
	container.add_theme_constant_override("margin_right", margin)


static func set_container_to_expand_fully(container: Container) -> void:
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.size_flags_vertical = Control.SIZE_EXPAND_FILL


func _form_sense_node_class_caches() -> void:
	var global_class_list: Array[Dictionary] = ProjectSettings.get_global_class_list()

	_sense_tree_classes = {}
	_sense_tree_composites = []
	_sense_tree_decorators = []
	_sense_tree_leaves = []

	for class_definition in global_class_list:
		_process_class_definition(class_definition)


func _process_class_definition(class_definition: Dictionary) -> void:
	if not _has_class_name(class_definition):
		return

	if not _is_sense_tree_class(class_definition):
		return

	var source_type = _get_node_source_type(class_definition)
	if source_type == SenseTreeConstants.NodeSourceType.UNKNOWN:
		return
	_sense_tree_classes[class_definition["class"]] = class_definition

	var definition_resource = load(class_definition["path"])
	var definition_instance = definition_resource.new()

	if not definition_instance is SenseTreeNode:
		definition_instance.queue_free()
		return

	var sense_node = definition_instance as SenseTreeNode

	var node_group: SenseTreeConstants.NodeGroup = sense_node.get_node_group()
	match node_group:
		SenseTreeConstants.NodeGroup.COMPOSITE:
			_sense_tree_composites.push_back(class_definition)
		SenseTreeConstants.NodeGroup.DECORATOR:
			_sense_tree_decorators.push_back(class_definition)
		SenseTreeConstants.NodeGroup.LEAF:
			_sense_tree_leaves.push_back(class_definition)
			match source_type:
				SenseTreeConstants.NodeSourceType.NATIVE:
					class_definition[SenseTreeConstants.SENSETREE_TYPE_IDENTIFIER_KEY] = (
						SenseTreeConstants.NATIVE_TYPE_IDENTIFIER_VALUE
					)
					_sense_native_tree_leaves.push_back(class_definition)
				SenseTreeConstants.NodeSourceType.EXAMPLE:
					class_definition[SenseTreeConstants.SENSETREE_TYPE_IDENTIFIER_KEY] = (
						SenseTreeConstants.EXAMPLE_TYPE_IDENTIFIER_VALUE
					)
					_sense_example_tree_leaves.push_back(class_definition)
				SenseTreeConstants.NodeSourceType.CUSTOM:
					class_definition[SenseTreeConstants.SENSETREE_TYPE_IDENTIFIER_KEY] = (
						SenseTreeConstants.CUSTOM_TYPE_IDENTIFIER_VALUE
					)
					_sense_custom_tree_leaves.push_back(class_definition)
		_:
			pass

	definition_instance.queue_free()
	return


func _has_class_name(class_definition: Dictionary) -> bool:
	return class_definition != null and "class" in class_definition


func _is_sense_tree_class(class_definition: Dictionary) -> bool:
	return _sense_tree_class_regex.search(class_definition["class"]) != null


func _get_node_source_type(class_definition: Dictionary) -> SenseTreeConstants.NodeSourceType:
	if not "path" in class_definition:
		return SenseTreeConstants.NodeSourceType.UNKNOWN

	if _native_nodes_path_pattern.search(class_definition["path"]) != null:
		return SenseTreeConstants.NodeSourceType.NATIVE
	if _example_nodes_path_pattern.search(class_definition["path"]) != null:
		return SenseTreeConstants.NodeSourceType.EXAMPLE
	if _custom_nodes_path_pattern.search(class_definition["path"]) != null:
		return SenseTreeConstants.NodeSourceType.CUSTOM

	return SenseTreeConstants.NodeSourceType.UNKNOWN
