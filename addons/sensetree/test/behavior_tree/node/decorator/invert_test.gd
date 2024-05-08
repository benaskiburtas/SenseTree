# GdUnit generated TestSuite
class_name SenseTreeInvertDecoratorTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const INVERT_DECORATOR_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/decorator/invert.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var invert_decorator_node: SenseTreeInvertDecorator
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var invert_decorator_script = load(INVERT_DECORATOR_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	invert_decorator_node = auto_free(invert_decorator_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(invert_decorator_node)


func test_tick_returns_failure_when_no_child_present() -> void:
	# Given
	var expected_status = SenseTreeNode.Status.FAILURE

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)


func test_tick_returns_success_when_child_returns_failure() -> void:
	# Given
	var child_failure_mock = mock(SenseTreeConditionLeaf)
	var mocked_child_result = SenseTreeNode.Status.FAILURE
	do_return(mocked_child_result).on(child_failure_mock).tick(actor, blackboard)
	invert_decorator_node.add_child(child_failure_mock)

	var expected_status = SenseTreeNode.Status.SUCCESS

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)
	verify(child_failure_mock).tick(actor, blackboard)


func test_tick_returns_failure_when_child_returns_success() -> void:
	# Given
	var child_success_mock = mock(SenseTreeConditionLeaf)
	var mocked_child_result = SenseTreeNode.Status.SUCCESS
	do_return(mocked_child_result).on(child_success_mock).tick(actor, blackboard)
	invert_decorator_node.add_child(child_success_mock)

	var expected_status = SenseTreeNode.Status.FAILURE

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)
	verify(child_success_mock).tick(actor, blackboard)
