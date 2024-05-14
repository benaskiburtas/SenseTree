class_name HarvestableNode extends Node2D

enum HarvestableState { AVAILABLE, REGENERATING, HARVESTED }

@export var texture_available: Texture2D = null
@export var texture_regenerating: Texture2D = null
@export var texture_harvested: Texture2D = null

@export_range(0, 60) var time_till_regenerating: float = 2
@export_range(0, 60) var time_till_available: float = 5

@onready var _current_sprite: Sprite2D = $"Sprite2D"

var _regrow_timer: Timer

var _harvestable_state: HarvestableState = HarvestableState.AVAILABLE:
	set(new_harvestable_state):
		_harvestable_state = new_harvestable_state
		_assign_sprite_by_state()


func _init():
	_regrow_timer = Timer.new()
	_regrow_timer.autostart = false
	_regrow_timer.one_shot = true


func _ready():
	add_child(_regrow_timer, false, Node.INTERNAL_MODE_BACK)
	_regrow_timer.connect("timeout", _on_regrow_timer_timeout)
	_assign_sprite_by_state()


func is_ready_for_harvest() -> bool:
	return not _harvestable_state == HarvestableState.AVAILABLE


func harvest_resource() -> bool:
	if _harvestable_state == HarvestableState.AVAILABLE:
		_harvestable_state = HarvestableState.HARVESTED
		_regrow_timer.start(time_till_regenerating)
		return true
	else:
		return false


func _assign_sprite_by_state() -> void:
	match _harvestable_state:
		HarvestableState.AVAILABLE:
			if texture_available != null:
				_current_sprite.texture = texture_available
		HarvestableState.REGENERATING:
			if texture_regenerating != null:
				_current_sprite.texture = texture_regenerating
		HarvestableState.HARVESTED:
			if texture_harvested != null:
				_current_sprite.texture = texture_harvested


func _on_regrow_timer_timeout() -> void:
	match _harvestable_state:
		HarvestableState.AVAILABLE:
			return
		HarvestableState.REGENERATING:
			_harvestable_state = HarvestableState.AVAILABLE
		HarvestableState.HARVESTED:
			_harvestable_state = HarvestableState.REGENERATING
			_regrow_timer.start(time_till_available)
