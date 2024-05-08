# GdUnit generated TestSuite
class_name SenseTreeRandomizeDecoratorTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const RANDOMIZE_DECORATOR_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/decorator/randomize.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var randomize_decorator_node: SenseTreeRandomizeDecorator
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var randomize_decorator_script = load(RANDOMIZE_DECORATOR_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	randomize_decorator_node = auto_free(randomize_decorator_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(randomize_decorator_node)


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
	randomize_decorator_node.success_probability = 0.0
	do_return(mocked_child_result).on(child_failure_mock).tick(actor, blackboard)
	randomize_decorator_node.add_child(child_failure_mock)

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
	randomize_decorator_node.success_probability = 100.0
	do_return(mocked_child_result).on(child_mock).tick(actor, blackboard)
	randomize_decorator_node.add_child(child_mock)

	var expected_status = SenseTreeNode.Status.SUCCESS

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)
	verify(child_mock).tick(actor, blackboard)


func test_tick_correctly_randomizes_seeded_results() -> void:
	# Given
	var seed = 69
	randomize_decorator_node.random_generator.seed = seed

	var child_mock = mock(SenseTreeConditionLeaf)
	var mocked_child_result = SenseTreeNode.Status.SUCCESS
	do_return(mocked_child_result).on(child_mock).tick(actor, blackboard)
	randomize_decorator_node.add_child(child_mock)

	# When
	var results = []
	for i in range(0, 5):
		results.push_back(randomize_decorator_node.tick(actor, blackboard))

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
	var result_class_name = randomize_decorator_node.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)


func test_get_exported_properties() -> void:
	# Given
	var initial_success_probability_value: float = 50
	var final_success_probability_value: float = 85

	var expected_initial_probability_property = SenseTreeExportedProperty.new(
		"success_probability", "Success Probability", initial_success_probability_value
	)

	var expected_final_probability_property = SenseTreeExportedProperty.new(
		"success_probability", "Success Probability", final_success_probability_value
	)

	# When
	var initial_properties = randomize_decorator_node.get_exported_properties()
	randomize_decorator_node.success_probability = final_success_probability_value
	var final_properties = randomize_decorator_node.get_exported_properties()

	# Then
	assert_array(initial_properties).contains([expected_initial_probability_property])
	assert_array(final_properties).contains([expected_final_probability_property])
