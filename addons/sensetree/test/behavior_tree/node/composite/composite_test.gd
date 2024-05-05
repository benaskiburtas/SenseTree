# GdUnit generated TestSuite
class_name SenseTreeCompositeNodeTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const COMPOSITE_NODE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/composite/composite.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var composite: SenseTreeCompositeNode
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var composite_node_script = load(COMPOSITE_NODE_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	composite = auto_free(composite_node_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(composite)


func test_shuffle_children_order() -> void:
	# Given
	seed(50)

	var child_mock_a = mock(SenseTreeConditionLeaf)
	var child_mock_b = mock(SenseTreeConditionLeaf)
	var child_mock_c = mock(SenseTreeConditionLeaf)
	var child_mock_d = mock(SenseTreeConditionLeaf)
	var child_mock_e = mock(SenseTreeConditionLeaf)

	composite.add_child(child_mock_a)
	composite.add_child(child_mock_b)
	composite.add_child(child_mock_c)
	composite.add_child(child_mock_d)
	composite.add_child(child_mock_e)

	# When
	composite.shuffle_children_order()

	# Then
	var result_a = composite.get_child(1)
	var result_b = composite.get_child(2)
	var result_c = composite.get_child(0)
	var result_d = composite.get_child(3)
	var result_e = composite.get_child(4)

	assert_bool(result_a == child_mock_a).is_true()
	assert_bool(result_b == child_mock_b).is_true()
	assert_bool(result_c == child_mock_c).is_true()
	assert_bool(result_d == child_mock_d).is_true()
	assert_bool(result_e == child_mock_e).is_true()


func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeCompositeNode"

	# When
	var result_class_name = composite.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)
