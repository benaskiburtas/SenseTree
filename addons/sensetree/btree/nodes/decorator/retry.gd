@tool
@icon("../../icons/placeholder.svg")
class_name SenseTreeRetryDecorator
extends SenseTreeDecorator

@export_range(0, 100000) var retry_limit: int = 0

var current_retries : int = 0

func _ready():
	current_retries = 0

func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if current_retries < retry_limit:
		var child = get_child(0)
		var result = child.tick(actor, blackboard)
		
		if result == Status.SUCCESS:
			return Status.SUCCESS
		if result == Status.RUNNING:
			return Status.RUNNING
		
		current_retries += 1
		
		if current_retries >= retry_limit:
			return Status.FAILURE
		
		return Status.RUNNING
	else:
		return Status.FAILURE
