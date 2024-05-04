# GdUnit generated TestSuite
class_name SenseTreeRepeatDecoratorTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const REPEAT_DECORATOR_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/decorator/repeat.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

# Decorator exported properties
const DEFAULT_REPEAT_LIMIT_VALUE: int = 5

var repeat_decorator: SenseTreeRepeatDecorator
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var repeat_decorator_script = load(REPEAT_DECORATOR_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	repeat_decorator = auto_free(repeat_decorator_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(repeat_decorator)


func test_tick_returns_failure_when_no_child_present() -> void:
	# Given
	var expected_status = SenseTreeNode.Status.FAILURE

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)


func test_tick_statuses_when_repeat_limit_is_three() -> void:
	# Given
	repeat_decorator.repeat_limit = 3
	var child_mock = mock(SenseTreeConditionLeaf)
	repeat_decorator.add_child(child_mock)

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
	repeat_decorator.add_child(child_running_mock)

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
	var result_class_name = repeat_decorator.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)


func test_get_exported_properties() -> void:
	# Given
	var expected_properties = SenseTreeExportedProperty.new(
		"repeat_limit", "Repeat Limit", DEFAULT_REPEAT_LIMIT_VALUE
	)

	# When
	var result_properties = repeat_decorator.get_exported_properties()

	# Then
	assert_array(result_properties).contains_exactly([expected_properties])
