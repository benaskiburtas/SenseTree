@tool
@icon("res://addons/sensetree/btree/icon/Success.svg")
class_name SenseTreeSuccessDecorator
extends SenseTreeDecorator


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	var child = get_child(0) as SenseTreeNode
	child.tick(actor, blackboard)
	return Status.SUCCESS


func get_sensenode_class() -> String:
	return "SenseTreeSuccessDecorator"
