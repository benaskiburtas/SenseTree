@tool
class_name ResourceHashVerifier
extends Node

const DEFAULT_HASH = HashingContext.HASH_MD5

var _hashing_context: HashingContext
var _previous_resource: Resource
var _previous_resource_hash: PackedByteArray


func _init() -> void:
	_hashing_context = HashingContext.new()


func is_resource_modified(resource: Resource) -> bool:
	if not _previous_resource or _previous_resource != resource:
		_previous_resource = resource
		_previous_resource_hash = _generate_resource_hash(resource)
		return true

	var current_resource_hash = _generate_resource_hash(resource)
	if _previous_resource_hash != current_resource_hash:
		_previous_resource_hash = current_resource_hash
		return true
	return false


func _generate_resource_hash(resource: Resource) -> PackedByteArray:
	if not resource:
		return PackedByteArray()
	_hashing_context.start(DEFAULT_HASH)
	_hashing_context.update(var_to_bytes_with_objects(resource))
	var hash = _hashing_context.finish()
	return hash
