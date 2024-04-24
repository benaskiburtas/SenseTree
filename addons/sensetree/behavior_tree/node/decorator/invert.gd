@tool
@icon("res://addons/sensetree/behavior_tree/icon/Invert.svg")
class_name SenseTreeInvertDecorator
extends SenseTreeDecorator


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	var result = Status.SUCCESS
	var child: SenseTreeNode
	if get_child_count() != 0:
		child = get_child(0)
	if child:
		result = child.tick(actor, blackboard)
	return return_inverted_status(result)


func return_inverted_status(child_status: Status) -> Status:
	if child_status == Status.SUCCESS:
		return Status.FAILURE
	if child_status == Status.FAILURE:
		return Status.SUCCESS
	return Status.RUNNING


func get_sensenode_class() -> String:
	return "SenseTreeInvertDecorator"
