@tool
@icon("../../../icons/placeholder.svg")
class_name SenseTreeSelectorComposite
extends SenseTreeCompositeNode


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	for child in get_children():
		var child_status = child.tick(actor, blackboard)
		if child_status != Status.FAILURE: 
			return child_status
	return Status.FAILURE
