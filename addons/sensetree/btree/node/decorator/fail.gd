@tool
@icon("res://addons/sensetree/btree/icon/Fail.svg")
class_name SenseTreeFailDecorator
extends SenseTreeDecorator


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	var child = get_child(0) as SenseTreeNode
	child.tick(actor, blackboard)
	return Status.FAILURE


func get_sensenode_class() -> String:
	return "SenseTreeFailDecorator"
