@tool
@icon("res://addons/sensetree/behavior_tree/icon/Action.svg")
class_name SenseTreeAttackAction
extends SenseTreeActionLeaf

#Entity attacks a target in range

@export var claimed_resource_key: String
@export var claimed_resource_amount: int

const chase_target_key: String = "CHASE_TARGET_KEY"

func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if not blackboard.has_key(chase_target_key):
		return Status.FAILURE
	if not blackboard.get_value(chase_target_key):
		return Status.FAILURE
	var target = blackboard.get_value(chase_target_key)
	if not target is AttackableActor:
		return Status.FAILURE
	var attackable = target as AttackableActor
	attackable.attack()
	return Status.SUCCESS if super.tick(actor, blackboard) else Status.FAILURE

func get_sensenode_class() -> String:
	return "SenseTreeAttackAction"

func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var claimed_resource_key_property = SenseTreeExportedProperty.new(
		"claimed_resource_key", "Claimed Resource Key", claimed_resource_key
	)
	var claimed_resource_amount_property = SenseTreeExportedProperty.new(
		"claimed_resource_amount", "Claimed Resource Amount", claimed_resource_amount
	)
	return [claimed_resource_key_property, claimed_resource_amount_property]
