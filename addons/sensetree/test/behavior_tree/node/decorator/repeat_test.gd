# GdUnit generated TestSuite
class_name SenseTreeRepeatDecoratorTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const REPEAT_DECORATOR_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/decorator/repeat.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var repeat_decorator_node: SenseTreeRepeatDecorator
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var repeat_decorator_script = load(REPEAT_DECORATOR_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	repeat_decorator_node = auto_free(repeat_decorator_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(repeat_decorator_node)


func test_tick_returns_failure_when_no_child_present() -> void:
	# Given
	var expected_status = SenseTreeNode.Status.FAILURE

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)


func test_tick_statuses_when_repeat_limit_is_three() -> void:
	# Given
	repeat_decorator_node.repeat_limit = 3
	var child_mock = mock(SenseTreeConditionLeaf)
	repeat_decorator_node.add_child(child_mock)

	# Mock Failure
	do_return(SenseTreeNode.Status.FAILURE).on(child_mock).tick(actor, blackboard)

	# When
	var actual_failure_result = sensetree.tick(actor, blackboard)

	# Re-mock for success to test Running/Success limits
	do_return(SenseTreeNode.Status.SUCCESS).on(child_mock).tick(actor, blackboard)

	var actual_running_result = SenseTreeNode.Status.RUNNING
	for n in range(0, 2):
		var tick_result = sensetree.tick(actor, blackboard)
		actual_running_result = (
			actual_running_result
			if actual_running_result != SenseTreeNode.Status.RUNNING
			else tick_result
		)

	var actual_success_result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(actual_failure_result).is_equal(SenseTreeNode.Status.FAILURE)
	assert_that(actual_running_result).is_equal(SenseTreeNode.Status.RUNNING)
	assert_that(actual_success_result).is_equal(SenseTreeNode.Status.SUCCESS)
	verify(child_mock, 4).tick(actor, blackboard)


func test_tick_returns_running_when_child_returns_running() -> void:
	# Given
	var child_running_mock = mock(SenseTreeConditionLeaf)
	var mocked_child_result = SenseTreeNode.Status.RUNNING
	do_return(mocked_child_result).on(child_running_mock).tick(actor, blackboard)
	repeat_decorator_node.add_child(child_running_mock)

	var expected_status = SenseTreeNode.Status.RUNNING

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)
	verify(child_running_mock).tick(actor, blackboard)


func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeRepeatDecorator"

	# When
	var result_class_name = repeat_decorator_node.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)


func test_get_exported_properties() -> void:
	# Given
	var initial_repeat_limit_value: int = 5
	var final_repeat_limit_value: int = 15

	var expected_initial_repeat_limit = SenseTreeExportedProperty.new(
		"repeat_limit", "Repeat Limit", initial_repeat_limit_value
	)

	var expected_final_repeat_limit = SenseTreeExportedProperty.new(
		"repeat_limit", "Repeat Limit", final_repeat_limit_value
	)

	# When
	var initial_properties = repeat_decorator_node.get_exported_properties()
	repeat_decorator_node.repeat_limit = final_repeat_limit_value
	var final_properties = repeat_decorator_node.get_exported_properties()

	# Then
	assert_array(initial_properties).contains([expected_initial_repeat_limit])
	assert_array(final_properties).contains([expected_final_repeat_limit])
