# GdUnit generated TestSuite
class_name SenseTreeRandomizeDecoratorTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const RANDOMIZE_DECORATOR_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/decorator/randomize.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

# Decorator exported properties
const DEFAULT_SUCCESS_PROBABILITY_VALUE: float = 50

var randomize_decorator: SenseTreeRandomizeDecorator
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var randomize_decorator_script = load(RANDOMIZE_DECORATOR_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	randomize_decorator = auto_free(randomize_decorator_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(randomize_decorator)


func test_tick_returns_failure_when_no_child_present() -> void:
	# Given
	var expected_status = SenseTreeNode.Status.FAILURE

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)


func test_tick_returns_failure_when_succes_probability_0() -> void:
	# Given
	var child_failure_mock = mock(SenseTreeConditionLeaf)
	var mocked_child_result = SenseTreeNode.Status.FAILURE
	randomize_decorator.success_probability = 0.0
	do_return(mocked_child_result).on(child_failure_mock).tick(actor, blackboard)
	randomize_decorator.add_child(child_failure_mock)

	var expected_status = SenseTreeNode.Status.FAILURE

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)
	verify(child_failure_mock).tick(actor, blackboard)


func test_tick_returns_success_when_succes_probability_100() -> void:
	# Given
	var child_mock = mock(SenseTreeConditionLeaf)
	var mocked_child_result = SenseTreeNode.Status.SUCCESS
	randomize_decorator.success_probability = 100.0
	do_return(mocked_child_result).on(child_mock).tick(actor, blackboard)
	randomize_decorator.add_child(child_mock)

	var expected_status = SenseTreeNode.Status.SUCCESS

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)
	verify(child_mock).tick(actor, blackboard)


func test_tick_correctly_randomizes_seeded_results() -> void:
	# Given
	var seed = 69
	randomize_decorator.random_generator.seed = seed

	var child_mock = mock(SenseTreeConditionLeaf)
	var mocked_child_result = SenseTreeNode.Status.SUCCESS
	do_return(mocked_child_result).on(child_mock).tick(actor, blackboard)
	randomize_decorator.add_child(child_mock)

	# When
	var results = []
	for i in range(0, 5):
		results.push_back(randomize_decorator.tick(actor, blackboard))

	# Then
	(
		assert_array(results)
		. contains_exactly(
			[
				SenseTreeNode.Status.SUCCESS,
				SenseTreeNode.Status.FAILURE,
				SenseTreeNode.Status.SUCCESS,
				SenseTreeNode.Status.FAILURE,
				SenseTreeNode.Status.SUCCESS,
			]
		)
	)


func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeRandomizeDecorator"

	# When
	var result_class_name = randomize_decorator.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)
	pass


func test_get_exported_properties() -> void:
	# Given
	var expected_properties = SenseTreeExportedProperty.new(
		"success_probability", "Success Probability", DEFAULT_SUCCESS_PROBABILITY_VALUE
	)

	# When
	var result_properties = randomize_decorator.get_exported_properties()

	# Then
	assert_array(result_properties).contains_exactly([expected_properties])
