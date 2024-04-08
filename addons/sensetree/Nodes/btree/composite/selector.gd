@tool
@icon("../../../icons/selector.svg")
class_name SenseTreeSelectorComposite
extends SenseTreeCompositeNode

var last_running_index: int = 0

func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	for child_index in range(last_running_index, get_children().size()):
		var child = get_child(child_index)
		var result: Status = child.tick(actor, blackboard)
		
		if result == Status.SUCCESS:
			reset()
			return Status.SUCCESS
			
		if result == Status.FAILURE:
			continue
			
		if result == Status.RUNNING:
			last_running_index = child_index
			return Status.RUNNING
	reset()
	return Status.FAILURE
			
func reset() -> void:
	last_running_index = 0
