extends Node

# Enums
enum ProcessMode { IDLE, PHYSICS }
enum NodeGroup { TREE, COMPOSITE, DECORATOR, LEAF, UNKNOWN }

# Color Constants
const TREE_GROUP_BASE_COLOR = Color("#19782a")
const COMPOSITE_GROUP_BASE_COLOR = Color("#193e78")
const DECORATOR_GROUP_BASE_COLOR = Color("#571978")
const LEAF_GROUP_BASE_COLOR = Color("#784819")
const FALL_BACK_COLOR = Color("#000000")
