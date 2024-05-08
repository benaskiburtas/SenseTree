# GdUnit generated TestSuite
class_name SenseTreeRetryDecoratorTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const RETRY_DECORATOR_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/decorator/retry.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var retry_decorator_node: SenseTreeRetryDecorator
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var retry_decorator_script = load(RETRY_DECORATOR_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	retry_decorator_node = auto_free(retry_decorator_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(retry_decorator_node)


func test_tick_returns_failure_when_no_child_present() -> void:
	# Given
	var expected_status = SenseTreeNode.Status.FAILURE

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)


func test_tick_statuses_when_repeat_limit_is_three() -> void:
	# Given
	retry_decorator_node.retry_limit = 5
	var child_mock = mock(SenseTreeConditionLeaf)
	retry_decorator_node.add_child(child_mock)

	# Mock Failure
	do_return(SenseTreeNode.Status.SUCCESS).on(child_mock).tick(actor, blackboard)

	# When
	var actual_success_result = sensetree.tick(actor, blackboard)

	# Re-mock for success to test Running/Success limits
	do_return(SenseTreeNode.Status.FAILURE).on(child_mock).tick(actor, blackboard)

	var actual_running_result = SenseTreeNode.Status.RUNNING
	for n in range(0, 4):
		var tick_result = sensetree.tick(actor, blackboard)
		actual_running_result = (
			actual_running_result
			if actual_running_result != SenseTreeNode.Status.RUNNING
			else tick_result
		)

	var actual_failure_result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(actual_success_result).is_equal(SenseTreeNode.Status.SUCCESS)
	assert_that(actual_running_result).is_equal(SenseTreeNode.Status.RUNNING)
	assert_that(actual_failure_result).is_equal(SenseTreeNode.Status.FAILURE)
	verify(child_mock, 6).tick(actor, blackboard)


func test_tick_returns_running_when_child_returns_running() -> void:
	# Given
	var child_running_mock = mock(SenseTreeConditionLeaf)
	var mocked_child_result = SenseTreeNode.Status.RUNNING
	do_return(mocked_child_result).on(child_running_mock).tick(actor, blackboard)
	retry_decorator_node.add_child(child_running_mock)

	var expected_status = SenseTreeNode.Status.RUNNING

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)
	verify(child_running_mock).tick(actor, blackboard)


func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeRetryDecorator"

	# When
	var result_class_name = retry_decorator_node.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)


func test_get_exported_properties() -> void:
	# Given
	var initial_retry_limit_value: int = 5
	var final_retry_limit_value: int = 15

	var expected_initial_retry_limit = SenseTreeExportedProperty.new(
		"retry_limit", "Retry Limit", initial_retry_limit_value
	)

	var expected_final_retry_limit = SenseTreeExportedProperty.new(
		"retry_limit", "Retry Limit", final_retry_limit_value
	)

	# When
	var initial_properties = retry_decorator_node.get_exported_properties()
	retry_decorator_node.retry_limit = final_retry_limit_value
	var final_properties = retry_decorator_node.get_exported_properties()

	# Then
	assert_array(initial_properties).contains([expected_initial_retry_limit])
	assert_array(final_properties).contains([expected_final_retry_limit])
