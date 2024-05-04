# GdUnit generated TestSuite
class_name SenseTreeSuccessDecoratorTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const SUCCESS_DECORATOR_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/decorator/success.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var success_decorator: SenseTreeSuccessDecorator
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var success_decorator_script = load(SUCCESS_DECORATOR_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	success_decorator = auto_free(success_decorator_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(success_decorator)


func test_tick_returns_success_when_no_child_present() -> void:
	# Given
	var expected_status = SenseTreeNode.Status.SUCCESS

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)


func test_tick_returns_success_when_child_returns_success() -> void:
	# Given
	var child_success_mock = mock(SenseTreeConditionLeaf)
	var mocked_child_result = SenseTreeNode.Status.SUCCESS
	do_return(mocked_child_result).on(child_success_mock).tick(actor, blackboard)
	success_decorator.add_child(child_success_mock)

	var expected_status = SenseTreeNode.Status.SUCCESS

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)
	verify(child_success_mock).tick(actor, blackboard)


func test_tick_returns_success_when_child_returns_failure() -> void:
	# Given
	var child_success_mock = mock(SenseTreeConditionLeaf)
	var mocked_child_result = SenseTreeNode.Status.FAILURE
	do_return(mocked_child_result).on(child_success_mock).tick(actor, blackboard)
	success_decorator.add_child(child_success_mock)

	var expected_status = SenseTreeNode.Status.SUCCESS

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)
	verify(child_success_mock).tick(actor, blackboard)
