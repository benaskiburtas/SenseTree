# GdUnit generated TestSuite
class_name SenseTreeNodeTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const SENSETREE_NODE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/node.gd"
const CONDITION_LEAF_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/leaf/condition.gd"
const SENSETREE_SOURCE_PATH: String = "res://addons/sensetree/behavior_tree/node/tree.gd"

var sensetree_node: SenseTreeNode
var actor: Node
var blackboard: SenseTreeBlackboard


func before_test() -> void:
	var sensetree_node_script = load(SENSETREE_NODE_SOURCE_PATH)
	var sensetree_script = load(SENSETREE_SOURCE_PATH)

	sensetree_node = auto_free(sensetree_node_script.new())

	actor = auto_free(Node.new())
	blackboard = auto_free(SenseTreeBlackboard.new())


func test_tick_function() -> void:
	# Given
	var expected_status = SenseTreeNode.Status.SUCCESS

	# When
	var result = sensetree_node.tick(actor, blackboard)

	# Then
	assert_that(result).is_equal(expected_status)


func test_get_sensenode_class() -> void:
	# Given
	var expected_class_name = "SenseTreeNode"

	# When
	var result_class_name = sensetree_node.get_sensenode_class()

	# Then
	assert_that(result_class_name).is_equal(expected_class_name)


func test_get_node_group() -> void:
	# Given
	var expected_node_group = SenseTreeConstants.NodeGroup.UNKNOWN

	# When
	var resulting_node_group = sensetree_node.get_node_group()

	# Then
	assert_that(resulting_node_group).is_equal(expected_node_group)


func test_get_exported_properties() -> void:
	# When
	var result_exported_properties = sensetree_node.get_exported_properties()

	# Then
	assert_array(result_exported_properties).is_empty()


func test_has_children() -> void:
	var initial_has_children = sensetree_node.has_children()

	sensetree_node.add_child(auto_free(SenseTreeNode.new()))

	var final_has_children = sensetree_node.has_children()

	assert_bool(initial_has_children).is_false()
	assert_bool(final_has_children).is_true()
