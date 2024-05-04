@tool
@icon("res://addons/sensetree/behavior_tree/icon/Fail.svg")
class_name SenseTreeFailDecorator
extends SenseTreeDecorator


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	var child: SenseTreeNode
	if get_child_count() != 0:
		child = get_child(0)
		child.tick(actor, blackboard)
	return Status.FAILURE


func get_sensenode_class() -> String:
	return "SenseTreeFailDecorator"
