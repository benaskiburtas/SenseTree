#@tool
#@icon("res://addons/sensetree/example/icon/Guard_Area.svg")
#class_name SenseTreeGuardStationaryAction
#extends SenseTreeActionLeaf
#
##Entity stays in one place and watches for threats until interrupted (sees threat/unfilfilled need)
#
#func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	#_time_passed = Time.get_ticks_msec()
	#if _time_passed >= stand_guard_duration:
		#return Status.SUCCESS
	#else:
		#return Status.RUNNING
#
#func get_sensenode_class() -> String:
	#return "SenseTreeGuardStationaryAction"
#
