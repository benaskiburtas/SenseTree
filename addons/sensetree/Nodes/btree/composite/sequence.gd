@tool
@icon("../../../icons/placeholder.svg")
class_name SenseTreeSequenceComposite
extends SenseTreeCompositeNode

var last_success_index: int = 0

func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	for child_index in range(last_success_index, get_children().size()):
		var child = get_child(child_index)
		var result: Status = child.tick(actor, blackboard)
		
		if result == Status.SUCCESS:
			last_success_index = child_index
			continue
			
		if result == Status.FAILURE:
			reset()
			return Status.FAILURE
			
		if result == Status.RUNNING:
			return Status.RUNNING
	reset()
	return Status.SUCCESS
			
func reset() -> void:
	last_success_index = 0
