@tool
@icon("../../../icons/placeholder.svg")
class_name SenseTreeRepeatDecorator
extends SenseTreeDecorator

@export_range(0, 100000) var repeat_limit: int = 0

var current_repetitions : int = 0

func _ready():
	current_repetitions = 0

func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if current_repetitions >= repeat_limit:
		return Status.RUNNING
	else:
		var child = get_child(0)
		var result = child.tick(actor, blackboard)
		
		if result == Status.FAILURE:
			return Status.FAILURE
		if result == Status.RUNNING:
			return Status.RUNNING
		
		current_repetitions += 1
		
		if current_repetitions >= repeat_limit:
			return Status.SUCCESS
		
		return Status.RUNNING