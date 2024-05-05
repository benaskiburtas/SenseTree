# GdUnit generated TestSuite
class_name SenseTreeRandomSelectorCompositeTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const RANDOM_SELECTOR_COMPOSITE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/composite/random_selector.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var random_selector_composite: SenseTreeRandomSelectorComposite
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var random_selector_composite_script = load(RANDOM_SELECTOR_COMPOSITE_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	random_selector_composite = auto_free(random_selector_composite_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(random_selector_composite)


func test_tick_child_randomization() -> void:
	# Given
	seed(50)

	var child_mock_a = mock(SenseTreeConditionLeaf)
	var child_mock_b = mock(SenseTreeConditionLeaf)
	var child_mock_c = mock(SenseTreeConditionLeaf)
	var child_mock_d = mock(SenseTreeConditionLeaf)
	var child_mock_e = mock(SenseTreeConditionLeaf)

	do_return(SenseTreeNode.Status.SUCCESS).on(child_mock_a).tick(actor, blackboard)
	do_return(SenseTreeNode.Status.SUCCESS).on(child_mock_b).tick(actor, blackboard)
	do_return(SenseTreeNode.Status.SUCCESS).on(child_mock_c).tick(actor, blackboard)
	do_return(SenseTreeNode.Status.SUCCESS).on(child_mock_d).tick(actor, blackboard)
	do_return(SenseTreeNode.Status.SUCCESS).on(child_mock_e).tick(actor, blackboard)

	random_selector_composite.add_child(child_mock_a)
	random_selector_composite.add_child(child_mock_b)
	random_selector_composite.add_child(child_mock_c)
	random_selector_composite.add_child(child_mock_d)
	random_selector_composite.add_child(child_mock_e)

	# When
	sensetree.tick(actor, blackboard)

	# Then
	var result_a = random_selector_composite.get_child(1)
	var result_b = random_selector_composite.get_child(2)
	var result_c = random_selector_composite.get_child(0)
	var result_d = random_selector_composite.get_child(3)
	var result_e = random_selector_composite.get_child(4)

	assert_bool(result_a == child_mock_a).is_true()
	assert_bool(result_b == child_mock_b).is_true()
	assert_bool(result_c == child_mock_c).is_true()
	assert_bool(result_d == child_mock_d).is_true()
	assert_bool(result_e == child_mock_e).is_true()


func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeRandomSelectorComposite"

	# When
	var result_class_name = random_selector_composite.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)
