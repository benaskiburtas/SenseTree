# GdUnit generated TestSuite
class_name SenseTreeSelectorCompositeTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const SELECTOR_COMPOSITE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/composite/selector.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var selector_composite: SenseTreeSelectorComposite
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var selector_composite_script = load(SELECTOR_COMPOSITE_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	selector_composite = auto_free(selector_composite_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(selector_composite)

func test_parameterized_child_index (child_a_status: int, child_b_status :int, child_c_status :int, expected_status :int, test_parameters := [
	[0, 0, 0, 0], [1, 0, 0, 0], [2, 0, 0, 2],
	[0, 1, 0, 0], [1, 1, 0, 0], [2, 1, 0, 2],
	[0, 2, 0, 0], [1, 2, 0, 2], [2, 2, 0, 2],
	[0, 0, 1, 0], [1, 0, 1, 0], [2, 0, 1, 2],
	[0, 0, 2, 0], [1, 0, 2, 0], [2, 0, 2, 2],
	[0, 1, 1, 0], [1, 1, 1, 1], [2, 1, 1, 2],
	[0, 1, 2, 0], [1, 1, 2, 2], [2, 1, 2, 2],
	[0, 2, 1, 0], [1, 2, 1, 2], [2, 2, 1, 2],
	[0, 2, 2, 0], [1, 2, 2, 2], [2, 2, 2, 2] ])  -> void:

	# Given
	var child_mock_a = mock(SenseTreeConditionLeaf)
	var child_mock_c = mock(SenseTreeConditionLeaf)
	var child_mock_b = mock(SenseTreeConditionLeaf)

	selector_composite.add_child(child_mock_a)
	selector_composite.add_child(child_mock_b)
	selector_composite.add_child(child_mock_c)

	do_return(child_a_status).on(child_mock_a).tick(actor, blackboard)
	do_return(child_b_status).on(child_mock_b).tick(actor, blackboard)
	do_return(child_c_status).on(child_mock_c).tick(actor, blackboard)

	# When
	var result = sensetree.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)

func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeSelectorComposite"

	# When
	var result_class_name = selector_composite.get_sensenode_class()

	# Then	assert_that(result_class_name).is_equal(expected_class_name)
