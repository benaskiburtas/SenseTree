@tool
@icon("res://addons/sensetree/behavior_tree/icon/Randomize.svg")
class_name SenseTreeRandomizeDecorator
extends SenseTreeDecorator

@export_range(0, 100) var success_probability: float = 50

var random_generator: RandomNumberGenerator


func _init() -> void:
	random_generator = RandomNumberGenerator.new()
	random_generator.randomize()


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	var child: SenseTreeNode
	if get_child_count() == 0:
		return Status.FAILURE
	child = get_child(0)
	var status = child.tick(actor, blackboard)
	return Status.RUNNING if status == Status.RUNNING else _pick_random_status()


func get_sensenode_class() -> String:
	return "SenseTreeRandomizeDecorator"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var success_probability_property = SenseTreeExportedProperty.new(
		"success_probability", "Success Probability", success_probability
	)
	return [success_probability_property]


func _pick_random_status() -> Status:
	var roll = random_generator.randf() * 100
	if roll < success_probability:
		return Status.SUCCESS
	else:
		return Status.FAILURE
