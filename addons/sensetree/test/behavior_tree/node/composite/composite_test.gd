# GdUnit generated TestSuite
class_name SenseTreeCompositeNodeTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const COMPOSITE_NODE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/composite/composite.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var composite_node: SenseTreeCompositeNode
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var composite_node_script = load(COMPOSITE_NODE_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	composite_node = auto_free(composite_node_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(composite_node)


func test_shuffle_children_order() -> void:
	# Given
	seed(50)

	var child_mock_a = mock(SenseTreeConditionLeaf)
	var child_mock_b = mock(SenseTreeConditionLeaf)
	var child_mock_c = mock(SenseTreeConditionLeaf)
	var child_mock_d = mock(SenseTreeConditionLeaf)
	var child_mock_e = mock(SenseTreeConditionLeaf)

	composite_node.add_child(child_mock_a)
	composite_node.add_child(child_mock_b)
	composite_node.add_child(child_mock_c)
	composite_node.add_child(child_mock_d)
	composite_node.add_child(child_mock_e)

	# When
	composite_node.shuffle_children_order()

	# Then
	var result_a = composite_node.get_child(1)
	var result_b = composite_node.get_child(2)
	var result_c = composite_node.get_child(0)
	var result_d = composite_node.get_child(3)
	var result_e = composite_node.get_child(4)

	assert_bool(result_a == child_mock_a).is_true()
	assert_bool(result_b == child_mock_b).is_true()
	assert_bool(result_c == child_mock_c).is_true()
	assert_bool(result_d == child_mock_d).is_true()
	assert_bool(result_e == child_mock_e).is_true()


func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeCompositeNode"

	# When
	var result_class_name = composite_node.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)


func test_get_node_group() -> void:
	# Given
	var expected_node_group = SenseTreeConstants.NodeGroup.COMPOSITE

	# When
	var result_node_group = composite_node.get_node_group()

	# Then
	assert_that(result_node_group).is_equal(expected_node_group)
