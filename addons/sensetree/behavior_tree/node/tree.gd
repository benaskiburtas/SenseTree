@tool
@icon("res://addons/sensetree/behavior_tree/icon/Tree.svg")
class_name SenseTree
extends SenseTreeNode

@export var is_enabled: bool = true:
	set(new_is_enabled):
		is_enabled = new_is_enabled
		_setup_process_modes()

@export var actor: Node:
	set(new_actor):
		actor = new_actor

@export var blackboard: SenseTreeBlackboard:
	set(new_blackboard):
		if blackboard:
			blackboard.free()
		blackboard = new_blackboard
		if not blackboard:
			blackboard = SenseTreeBlackboard.new()

@export
var tick_process_mode: SenseTreeConstants.ProcessMode = SenseTreeConstants.ProcessMode.PHYSICS
@export_range(0, 100) var frames_per_tick: int = 15

var _child: SenseTreeNode
var _frames_since_last_tick: int


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = super._get_configuration_warnings()
	var child_count = get_child_count()
	if child_count != 1:
		configuration_warnings.push_back("Behavior tree should have a single child node.")

	if tick_process_mode == null:
		configuration_warnings.push_back("Tick process mode should be set.")

	if actor == null:
		configuration_warnings.push_back("Behavior tree should have an assigned actor.")

	return configuration_warnings


func _ready() -> void:
	if not blackboard:
		blackboard = SenseTreeBlackboard.new()

	_setup_process_modes()
	_frames_since_last_tick = frames_per_tick - randi_range(0, frames_per_tick)


func _process(delta: float) -> void:
	_resolve_process()


func _physics_process(delta: float) -> void:
	_resolve_process()


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if not actor or not blackboard:
		return Status.FAILURE
	if not _child and not has_children():
		return Status.FAILURE
	if not _child and has_children():
		_child = get_child(0)
	return _child.tick(actor, blackboard)


func get_sensenode_class() -> String:
	return "SenseTree"


func get_node_group() -> SenseTreeConstants.NodeGroup:
	return SenseTreeConstants.NodeGroup.TREE


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var is_enabled_property = SenseTreeExportedProperty.new(
		"is_enabled", "Is Enabled", str(is_enabled)
	)
	var tick_process_mode_property = SenseTreeExportedProperty.new(
		"tick_process_mode",
		"Tick Process Mode",
		SenseTreeConstants.ProcessMode.keys()[tick_process_mode]
	)
	var frames_per_tick_property = SenseTreeExportedProperty.new(
		"Frames Per Tick", "Frames Per Tick", frames_per_tick
	)
	return [is_enabled_property, tick_process_mode_property, frames_per_tick_property]


func _is_in_editor() -> bool:
	return Engine.is_editor_hint()


func _resolve_process() -> void:
	if _is_in_editor() or not OS.is_debug_build():
		return

	if not is_enabled:
		return

	_frames_since_last_tick += 1

	if _frames_since_last_tick >= frames_per_tick:
		tick(actor, blackboard)
		_frames_since_last_tick = 0


func _setup_process_modes() -> void:
	if is_enabled:
		set_process(tick_process_mode == SenseTreeConstants.ProcessMode.IDLE)
		set_physics_process(tick_process_mode == SenseTreeConstants.ProcessMode.PHYSICS)
	else:
		set_process(false)
		set_physics_process(false)
