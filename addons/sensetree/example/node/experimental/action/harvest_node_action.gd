@tool
@icon("res://addons/sensetree/behavior_tree/icon/Action.svg")
class_name SensetreeHarvestNodeAction
extends SenseTreeActionLeaf

#Entity harvests a node and retrieves resources
#Mainly for farmland, possibly applicable to wildlife corpses or other nodes (fishing?)

@export var harvestable_nodes: Array[HarvestableNode]


func tick(actor, blackboard):
	for harvestable in harvestable_nodes:
		if not harvestable.is_ready_for_harvest():
			var harvest_result = harvestable.harvest()
			if harvest_result:
				return Status.SUCCESS
	return Status.FAILURE
