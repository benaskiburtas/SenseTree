@tool
extends Node

const PLUGIN_BASE_CLASS_PATTERN: String = "SenseTree"
const BEHAVIOR_TREE_NODE_PATH_PATTERN: String = "btree/node"
const DETECT_NODE_PATH_PATTERN: String = "detect"

var _sense_tree_class_regex: RegEx = RegEx.create_from_string(PLUGIN_BASE_CLASS_PATTERN)
var _btree_nodes_path_regex: RegEx = RegEx.create_from_string(BEHAVIOR_TREE_NODE_PATH_PATTERN)
var _detect_nodes_path_regex: RegEx = RegEx.create_from_string(DETECT_NODE_PATH_PATTERN)

var _sense_tree_classes: Dictionary
var _sense_tree_composites: Array[Dictionary]
var _sense_tree_decorators: Array[Dictionary]
var _sense_tree_leaves: Array[Dictionary]


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

	if not _has_node_script(class_definition):
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
		_:
			pass

	definition_instance.queue_free()
	return


func _has_class_name(class_definition: Dictionary) -> bool:
	return class_definition != null and "class" in class_definition


func _is_sense_tree_class(class_definition: Dictionary) -> bool:
	return _sense_tree_class_regex.search(class_definition["class"]) != null


func _has_node_script(class_definition: Dictionary) -> bool:
	if not "path" in class_definition:
		return false

	var is_behavior_tree_node = _btree_nodes_path_regex.search(class_definition["path"]) != null
	var is_detection_node = _detect_nodes_path_regex.search(class_definition["path"]) != null

	return true if is_behavior_tree_node or is_detection_node else false
