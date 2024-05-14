@tool
@icon("res://addons/sensetree/example/icon/Make_Noise.svg")
class_name SenseTreeChangeVisiblityAction
extends SenseTreeActionLeaf

enum ChangeVisibility { VISIBLE, INVISIBLE }

@export var change_visibility: ChangeVisibility


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if not actor:
		return Status.FAILURE

	if not actor is Node2D:
		return Status.FAILURE

	var actor_node2d := actor as Node2D
	if change_visibility == ChangeVisibility.INVISIBLE:
		actor_node2d.hide()
	if change_visibility == ChangeVisibility.VISIBLE:
		actor_node2d.show()
	
	return Status.SUCCESS
