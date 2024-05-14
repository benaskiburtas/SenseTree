class_name StorageNode extends Node2D

enum StorageState { EMPTY, PARTIAL, FULL }

@export_range(0, 100) var storage_capacity: int = 5

@export var texture_empty: Texture2D = null
@export var texture_partial: Texture2D = null
@export var texture_full: Texture2D = null

@onready var _current_sprite: Sprite2D = $"Sprite2D"

var _resources_stored: int = 0

var _storage_state: StorageState = StorageState.EMPTY:
	set(new_storage_state):
		_storage_state = new_storage_state
		_assign_sprite_by_state()


func _ready():
	_assign_sprite_by_state()


func is_empty() ->  bool:
	return _storage_state == StorageState.EMPTY

func has_free_space() -> bool:
	return _storage_state == StorageState.EMPTY or _storage_state == StorageState.PARTIAL

func has_stored_resources() -> bool:
	return _storage_state == StorageState.FULL or _storage_state == StorageState.PARTIAL


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
			if texture_empty != null:
				_current_sprite.texture = texture_empty
		StorageState.PARTIAL:
			if texture_partial != null:
				_current_sprite.texture = texture_partial
		StorageState.FULL:
			if texture_full != null:
				_current_sprite.texture = texture_full
