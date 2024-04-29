@tool
@icon("res://addons/sensetree/behavior_tree/icon/Randomize.svg")
class_name SenseTreeRandomizeDecorator
extends SenseTreeDecorator

@export_range(0, 100) var success_probability: float = 50


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	var child: SenseTreeNode
	if get_child_count() != 0:
		child = get_child(0)
	if child:
		child.tick(actor, blackboard)
	return _pick_random_status()


func get_sensenode_class() -> String:
	return "SenseTreeRandomizeDecorator"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var success_probability_property = SenseTreeExportedProperty.new(
		"success_probability", "Success Probability", success_probability
	)
	return [success_probability_property]


func _pick_random_status() -> Status:
	randomize()
	if randf() * 100 < success_probability:
		return Status.SUCCESS
	else:
		return Status.FAILURE
