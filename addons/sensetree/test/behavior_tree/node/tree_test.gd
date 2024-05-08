# GdUnit generated TestSuite
class_name SenseTreeTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard

func before_test() -> void:
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

func test_tick_returns_failure_when_actor_and_blackboard_not_present() -> void:
	# Given
	var expected_status = SenseTreeNode.Status.FAILURE

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)

func test_tick_retuns_failure_when_it_does_not_have_children() -> void:
	# Given
	var expected_status = SenseTreeNode.Status.FAILURE
	sensetree.actor = actor
	sensetree.blackboard = blackboard

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)

func test_tick_function() -> void:
	# Given
	var expected_status = SenseTreeNode.Status.SUCCESS
	sensetree.actor = actor
	sensetree.blackboard = blackboard

	var child = auto_free(SenseTreeNode.new())
	sensetree.add_child(child)

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)

func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTree"

	# When
	var result_class_name = sensetree.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)

func test_get_node_group() -> void:
	# Given
	var expected_node_group = SenseTreeConstants.NodeGroup.TREE

	# When
	var resulting_node_group = sensetree.get_node_group()

	# Then
	assert_that(resulting_node_group).is_equal(expected_node_group)

func test_get_exported_properties() -> void:
	# Given
	var initial_is_enabled_property: bool = false
	var initial_frames_per_tick_property: int = 30
	var initial_process_mode = SenseTreeConstants.ProcessMode.IDLE
	
	var final_is_enabled_property: bool = true
	var final_frames_per_tick_property: int = 60
	var final_process_mode = SenseTreeConstants.ProcessMode.PHYSICS

	var expected_initial_is_enabled_property = SenseTreeExportedProperty.new("is_enabled", "Is Enabled", "false")
	var expected_initial_frames_per_tick_property = SenseTreeExportedProperty.new(
		"Frames Per Tick", "Frames Per Tick", initial_frames_per_tick_property
	)
	var expected_initial_process_mode_property = SenseTreeExportedProperty.new(
		"tick_process_mode",
		"Tick Process Mode",
		"IDLE"
	)
	
	var expected_final_is_enabled_property = SenseTreeExportedProperty.new("is_enabled", "Is Enabled",  "true")
	var expected_final_frames_per_tick_property = SenseTreeExportedProperty.new(
		"Frames Per Tick", "Frames Per Tick", final_frames_per_tick_property
	)
	var expected_final_process_mode_property = SenseTreeExportedProperty.new(
		"tick_process_mode",
		"Tick Process Mode",
		"PHYSICS"
	)


	var expected_initial_exported_properties: Array = [
		expected_initial_is_enabled_property,
		expected_initial_process_mode_property,
		expected_initial_frames_per_tick_property
	]
	var expected_final_exported_properties: Array = [
		expected_final_is_enabled_property,
		expected_final_process_mode_property,
		expected_final_frames_per_tick_property
	]

	# When
	sensetree.is_enabled = initial_is_enabled_property
	sensetree.tick_process_mode = initial_process_mode
	sensetree.frames_per_tick = initial_frames_per_tick_property
	var initial_exported_properties = sensetree.get_exported_properties()

	sensetree.is_enabled = final_is_enabled_property
	sensetree.tick_process_mode = final_process_mode
	sensetree.frames_per_tick = final_frames_per_tick_property
	var final_exported_properties = sensetree.get_exported_properties()

	# Then
	assert_array(initial_exported_properties).contains(expected_initial_exported_properties)
	assert_array(final_exported_properties).contains(expected_final_exported_properties)
