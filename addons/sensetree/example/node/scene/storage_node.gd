class_name StorageNode extends Node2D

enum StorageState { EMPTY, PARTIAL, FULL }

@export_range(0, 100) var storage_capacity: int = 5

@export var sprite_empty: Sprite2D
@export var sprite_partial: Sprite2D
@export var sprite_full: Sprite2D

var _resources_stored: int = 0

var _storage_state: StorageState = StorageState.EMPTY:
	set(new_storage_state):
		_storage_state = new_storage_state
		_assign_sprite_by_state()

var _current_sprite: Sprite2D


func has_free_space() -> bool:
	return _storage_state == StorageState.EMPTY or _storage_state == StorageState.PARTIAL


func store_resource() -> bool:
	if _resources_stored >= storage_capacity:
		return false
	_resources_stored = _resources_stored + 1
	if _resources_stored >= storage_capacity:
		_storage_state = StorageState.FULL
	if _resources_stored < storage_capacity:
		_storage_state = StorageState.PARTIAL
	return true


func take_resource() -> bool:
	if _resources_stored == 0:
		return false
	_resources_stored = _resources_stored - 1
	if _resources_stored == 0:
		_storage_state = StorageState.EMPTY
	if _resources_stored > 0:
		_storage_state = StorageState.PARTIAL
	return true


func _assign_sprite_by_state() -> void:
	match _storage_state:
		StorageState.EMPTY:
			_current_sprite = sprite_empty
		StorageState.PARTIAL:
			_current_sprite = sprite_partial
		StorageState.FULL:
			_current_sprite = sprite_full
