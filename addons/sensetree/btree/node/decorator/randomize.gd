@tool
@icon("res://addons/sensetree/btree/icon/Randomize.svg")
class_name SenseTreeRandomizeDecorator
extends SenseTreeDecorator

@export_range(0, 100) var success_probability: float = 50


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	var child: SenseTreeNode
	if get_child_count() != 0:
		child = get_child(0)
	if child:
		child.tick(actor, blackboard)
	return pick_random_status()


func pick_random_status() -> Status:
	randomize()
	if randf() * 100 < success_probability:
		return Status.SUCCESS
	else:
		return Status.FAILURE


func get_sensenode_class() -> String:
	return "SenseTreeRandomizeDecorator"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var success_probability_property = SenseTreeExportedProperty.new()
	success_probability_property.property_name = "success_probability"
	success_probability_property.property_title = "Success Probability"
	success_probability_property.value = success_probability
	return [success_probability_property]
