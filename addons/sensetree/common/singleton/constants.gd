extends Node

# Enums
enum ProcessMode { IDLE, PHYSICS }
enum NodeGroup { UNKNOWN, TREE, COMPOSITE, DECORATOR, LEAF }
enum NodeSourceType { UNKNOWN, NATIVE, EXAMPLE, CUSTOM }

## String Constants
const PLUGIN_NODE_CLASS_PREFIX: String = "SenseTree"

# Path Regex Constants
const NATIIVE_NODE_PATH_PATTERN: String = "sensetree/behavior_tree/node"
const EXAMPLE_NODE_PATH_PATTERN: String = "sensetree/example/node"
const CUSTOM_NODE_PATH_PATTERN: String = "sensetree/custom/node"

# Class Metadata String Constants
const SENSETREE_TYPE_IDENTIFIER_KEY: String = "sensetree_type"

const NATIVE_TYPE_IDENTIFIER_VALUE: String = "sensetree_native"
const EXAMPLE_TYPE_IDENTIFIER_VALUE: String = "sensetree_example"
const CUSTOM_TYPE_IDENTIFIER_VALUE: String = "sensetree_custom"

# Color Constants
const TREE_GROUP_BASE_COLOR = Color("#19782a")
const COMPOSITE_GROUP_BASE_COLOR = Color("#193e78")
const DECORATOR_GROUP_BASE_COLOR = Color("#571978")
const LEAF_GROUP_BASE_COLOR = Color("#784819")
const FALL_BACK_COLOR = Color("#000000")
