@tool
class_name SenseTreeEditorContainer
extends Container

const PHYSICS_POLL_RATE: int = 60
const IDLE_POLL_RATE: int = 60

var _hashing_context: HashingContext
var _previous_tree_hash: PackedByteArray
var _current_physics_tick_count: int = 0
var _current_idle_tick_count: int = 0

@onready var _graph_edit: SenseTreeEditorGraphEdit = $SenseTreeEditor
@onready var _tree_list_vertical_box: VBoxContainer = $TreeList/TreeListMarginContainer/TreeListVerticalBox


func _enter_tree() -> void:
	_hashing_context = HashingContext.new()


func _ready() -> void:
	_populate_buttons([])


func _process(delta) -> void:
	_current_idle_tick_count += 1
	if _current_idle_tick_count >= IDLE_POLL_RATE:
		_current_idle_tick_count = 0
		var scene_trees = _get_scene_trees()
		if _is_update_needed(scene_trees):
			_clear_ui()
			_populate_buttons(scene_trees)


func _physics_process(delta) -> void:
	_current_physics_tick_count += 1
	if _current_physics_tick_count >= PHYSICS_POLL_RATE:
		_current_physics_tick_count = 0
		var scene_trees = _get_scene_trees()
		if _is_update_needed(scene_trees):
			_clear_ui()
			_populate_buttons(scene_trees)


func _is_update_needed(scene_trees: Array) -> bool:
	var current_tree_hash = _generate_tree_hash(scene_trees)

	if current_tree_hash != _previous_tree_hash:
		_previous_tree_hash = current_tree_hash
		return true
	return false


func _generate_tree_hash(tree_members: Array) -> PackedByteArray:
	if tree_members.is_empty():
		return PackedByteArray()
	_hashing_context.start(HashingContext.HASH_MD5)
	_hashing_context.update(tree_members)
	return _hashing_context.finish()


func _clear_ui() -> void:
	for child in _graph_edit.get_children():
		child.queue_free()
	for child in _tree_list_vertical_box.get_children():
		child.queue_free()


func _populate_buttons(scene_trees: Array) -> void:
	var scene: Node
	if Engine.is_editor_hint():
		scene = get_tree().edited_scene_root
	else:
		scene = get_tree().current_scene

	for tree in scene_trees:
		var button = SenseTreeEditorSelectButton.new(tree)
		button.connect("tree_selected", _on_tree_selected)
		_tree_list_vertical_box.add_child(button)


func _get_scene_trees() -> Array:
	var scene_trees = []

	var scene: Node
	if Engine.is_editor_hint():
		scene = get_tree().edited_scene_root
	else:
		scene = get_tree().current_scene

	for tree in _find_all_sense_trees(scene):
		scene_trees.append(tree)
	return scene_trees


func _find_all_sense_trees(node: Node) -> Array:
	var result = []
	if node is SenseTree:
		result.append(node)

	if node:
		for child in node.get_children():
			result.append_array(_find_all_sense_trees(child))

	return result


func _on_tree_selected(tree: SenseTree) -> void:
	_graph_edit._build_structure_from_tree(tree)
	
