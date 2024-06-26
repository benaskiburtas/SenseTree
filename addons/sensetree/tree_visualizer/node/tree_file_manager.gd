@tool
class_name TreeVisualizerFileManager
extends Node

signal tree_loaded(tree: SenseTree)

enum FileOperation { UNSET, LOAD, SAVE }

const SENSE_TREE_FILE_EXTENSION: String = "*.res"
const SENSE_TREE_FILE_DESCRIPTION: String = "SenseTree"
const MINIMUM_DIALOG_SIZE: Vector2i = Vector2i(1000, 500)

const FILE_DIALOG_ACCESS_MODE: EditorFileDialog.Access = EditorFileDialog.ACCESS_RESOURCES
const FILE_DIALOG_LOAD_FILE_MODE: EditorFileDialog.FileMode = EditorFileDialog.FILE_MODE_OPEN_FILE
const FILE_DIALOG_SAVE_FILE_MODE: EditorFileDialog.FileMode = EditorFileDialog.FILE_MODE_SAVE_FILE

var _load_file_dialog: EditorFileDialog
var _save_file_dialog: EditorFileDialog
var _resource_hash_verifier: ResourceHashVerifier = ResourceHashVerifier.new()

var _current_operation: FileOperation = FileOperation.UNSET
var _current_tree: SenseTree
var _resource_path: String


func _init() -> void:
	_initialize_file_dialogs()
	_connect_file_dialog_signals()


func new_tree() -> void:
	_current_tree = SenseTree.new()
	_current_tree.set_name("SenseTree")
	save_tree_as()


func load_tree() -> void:
	_current_operation = FileOperation.LOAD
	_load_file_dialog.popup_centered(MINIMUM_DIALOG_SIZE)


func save_tree(tree: SenseTree = null) -> void:
	if not _resource_path or not _current_tree:
		return
	else:
		_save_tree_to_file()


func save_tree_as(tree: SenseTree = null) -> void:
	if tree:
		_current_tree = tree

	if not _current_tree:
		push_warning("SenseTree Save Warning: No active tree to save.")
		return

	if not _validate_tree_structure(_current_tree):
		return

	_current_operation = FileOperation.SAVE
	_save_file_dialog.popup_centered(MINIMUM_DIALOG_SIZE)


func reload_tree() -> void:
	if not _resource_path or not _current_tree:
		return
	else:
		_load_tree_from_file()


func resave_tree() -> void:
	if not _resource_path or not _current_tree:
		return
	else:
		_save_tree_to_file()


func _initialize_file_dialogs() -> void:
	_load_file_dialog = EditorFileDialog.new()
	_load_file_dialog.access = FILE_DIALOG_ACCESS_MODE
	_load_file_dialog.file_mode = FILE_DIALOG_LOAD_FILE_MODE
	_load_file_dialog.add_filter(SENSE_TREE_FILE_EXTENSION, SENSE_TREE_FILE_DESCRIPTION)
	add_child(_load_file_dialog)

	_save_file_dialog = EditorFileDialog.new()
	_save_file_dialog.access = FILE_DIALOG_ACCESS_MODE
	_save_file_dialog.file_mode = FILE_DIALOG_SAVE_FILE_MODE
	_save_file_dialog.add_filter(SENSE_TREE_FILE_EXTENSION, SENSE_TREE_FILE_DESCRIPTION)
	add_child(_save_file_dialog)


func _validate_tree_structure(root: Node) -> bool:
	if not root is SenseTree:
		push_error("SenseTree Save/Load Error: Root node must be of type SenseTree.")
		return false

	var stack = []
	stack.push_back(root)

	while not stack.is_empty():
		var node = stack.pop_front()

		if not node is SenseTreeNode:
			push_error("SenseTree Save/Load Error: All tree nodes must be of type SenseTreeNode.")
			return false

		var node_children = node.get_children()

		for child in node_children:
			stack.push_front(child)

	return true


func _connect_file_dialog_signals() -> void:
	_load_file_dialog.connect("file_selected", _on_load_file_selected)
	_save_file_dialog.connect("file_selected", _on_save_file_selected)


func _save_tree_to_file() -> void:
	var tree_resource = PackedScene.new()
	tree_resource.pack(_current_tree)
	tree_resource.take_over_path(_resource_path)

	var save_result: Error = ResourceSaver.save(tree_resource)
	if not save_result == Error.OK:
		push_error(
			"SenseTree Save Error: Error whilst saving tree structure, error code %s." % save_result
		)
		return

	if Engine.is_editor_hint():
		EditorInterface.reload_scene_from_path(_resource_path)
	reload_tree()


func _load_tree_from_file() -> void:
	# Load & validate resource file
	var loaded_resource = ResourceLoader.load(_resource_path, "PackedScene")
	if not loaded_resource:
		push_error("SenseTree Load Error: Could not load resource file %s." % _resource_path)
		_reset()
		return

	if not loaded_resource is PackedScene or not loaded_resource.can_instantiate():
		push_error(
			"SenseTree Load Error: Not possible to instantiate stored resource %s." % _resource_path
		)
		return

	if not _resource_hash_verifier.is_resource_modified(loaded_resource):
		return

	# Cast to Scene and instantiate if this resource and current resource hash differs
	var scene_resource = loaded_resource as PackedScene

	# Duplicate to prevent signal reference issues
	var scene_tree = scene_resource.instantiate().duplicate()

	if not _validate_tree_structure(scene_tree):
		push_error(
			(
				"SenseTree Load Error: Loaded resource does not contain a valid tree structure %s."
				% _resource_path
			)
		)
		_reset()
		return

	# Clear current tree before re-assignment to avoid memory leaks
	if _current_tree and not _current_tree == scene_tree:
		_current_tree.free()

	# Re-assignment & emit loaded status
	_current_tree = scene_tree

	tree_loaded.emit(_current_tree)


func _reset() -> void:
	_current_tree.queue_free()

	_current_tree = null
	_resource_path = ""


func _on_load_file_selected(path: String) -> void:
	if not path:
		return

	if _resource_path != path:
		_resource_path = path

	_load_tree_from_file()


func _on_save_file_selected(path: String) -> void:
	if not path:
		return

	if _resource_path != path:
		_resource_path = path

	_save_tree_to_file()
