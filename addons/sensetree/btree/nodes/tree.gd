@tool
@icon("../icons/placeholder.svg")
class_name SenseTree
extends SenseTreeNode

enum TickProcessMode {
	IDLE,
	PHYSICS
}

@export var is_enabled: bool = true:
	set(new_is_enabled):
		is_enabled = new_is_enabled
		setup_process_modes()
		
@export var actor: Node:
	set(new_actor):
		actor = new_actor
		if not actor:
			set_default_actor()
		
@export var blackboard: SenseTreeBlackboard:
	set(new_blackboard):
		if blackboard:
			blackboard.free()
		blackboard = new_blackboard
		if not blackboard:
			blackboard = create_default_blackboard()
			
@export var tick_process_mode: TickProcessMode = TickProcessMode.PHYSICS
@export_range(0, 100) var ticks_per_frame: int = 1

var child: SenseTreeNode
var tick_count: int

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
	if not actor:
		set_default_actor()
	if not blackboard:
		blackboard = create_default_blackboard()
	
	setup_process_modes()
	tick_count = ticks_per_frame - randi_range(0, ticks_per_frame)
	
func _process(delta: float):
	resolve_process()
	
func _physics_process(delta: float):
	resolve_process()
	
func resolve_process():
	if is_in_editor():
		return
	
	if not is_enabled:
		return
	
	tick(actor, blackboard)

func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if not actor or not blackboard:
		return Status.FAILURE
	if not child and not get_child_count():
		return Status.FAILURE
	if not child and get_child_count():
		child = get_child(0)
	return child.tick(actor, blackboard)

func set_default_actor() -> void:
	actor = get_parent()

func create_default_blackboard() -> SenseTreeBlackboard:
	return SenseTreeBlackboard.new()

func is_in_editor() -> bool:
	return Engine.is_editor_hint()
	
func setup_process_modes() -> void:
	if is_enabled:
		set_process(tick_process_mode == TickProcessMode.IDLE)
		set_physics_process(tick_process_mode == TickProcessMode.PHYSICS)
	else:
		set_process(false)
		set_physics_process(false)
