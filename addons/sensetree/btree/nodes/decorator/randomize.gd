@tool
@icon("res://addons/sensetree/btree/icons/Randomize.svg")
class_name SenseTreeRandomizeDecorator
extends SenseTreeDecorator

@export_range(0, 100) var success_probability: float = 50


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	var child = get_child(0) as SenseTreeNode
	child.tick(actor, blackboard)
	return pick_random_status()


func pick_random_status() -> Status:
	randomize()
	if randf() * 100 < success_probability:
		return Status.SUCCESS
	else:
		return Status.FAILURE


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	return [SenseTreeExportedProperty.new("success_probability", "Success Probability", success_probability)]
