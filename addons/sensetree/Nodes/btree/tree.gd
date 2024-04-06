@tool
@icon("../icons/placeholder.svg")
class_name SenseTreeRoot
extends SenseTreeNode

func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if not get_child_count():
		return Status.FAILURE
	else:
		return get_child(0).tick()
