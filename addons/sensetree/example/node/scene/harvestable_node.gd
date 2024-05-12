class_name HarvestableNode extends Node2D

enum HarvestableState { AVAILABLE, REGENERATING, HARVESTED }

@export var sprite_available: Sprite2D
@export var sprite_regenerating: Sprite2D
@export var sprite_harvested: Sprite2D

var _harvestable_state: HarvestableState = HarvestableState.AVAILABLE:
	set(new_harvestable_state):
		_harvestable_state = new_harvestable_state
		_assign_sprite_by_state()

var _current_sprite: Sprite2D


func is_ready_for_harvest() -> bool:
	return not _harvestable_state == HarvestableState.AVAILABLE


func harvest_resource() -> bool:
	return true


func _assign_sprite_by_state() -> void:
	match _harvestable_state:
		HarvestableState.AVAILABLE:
			_current_sprite = sprite_available
		HarvestableState.REGENERATING:
			_current_sprite = sprite_regenerating
		HarvestableState.HARVESTED:
			_current_sprite = sprite_harvested
