# GdUnit generated TestSuite
class_name SenseTreeLeafNodeTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const LEAF_NODE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/leaf.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var leaf_node: SenseTreeLeafNode
var sensetree: SenseTree
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var leaf_node_script = load(LEAF_NODE_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	leaf_node = auto_free(leaf_node_script.new())
	sensetree = auto_free(sensetree_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())

	sensetree.actor = actor
	sensetree.blackboard = blackboard

	sensetree.add_child(leaf_node)


func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeLeafNode"

	# When
	var result_class_name = leaf_node.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)


func test_get_node_group() -> void:
	# Given
	var expected_node_group = SenseTreeConstants.NodeGroup.LEAF

	# When
	var result_node_group = leaf_node.get_node_group()

	# Then
	assert_that(result_node_group).is_equal(expected_node_group)
