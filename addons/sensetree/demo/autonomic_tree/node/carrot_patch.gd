class_name CarrotPatch extends HarvestableNode

# TODO: review which ones to use

const HARVESTED_TO_REGENERATING_STATE_DURATION: float = 5
const HARVESTED_TO_AVAILABLE_STATE_DURATION: float = 60

var _regrow_timer: Timer


func _init():
	_regrow_timer = Timer.new()
	_regrow_timer.autostart = false
	_regrow_timer.one_shot = true


func _ready():
	_regrow_timer.connect("timeout", _on_regrow_timer_timeout)


func harvest() -> bool:
	if HarvestableState.HARVESTED or HarvestableState.REGENERATING:
		return false

	if HarvestableState.AVAILABLE:
		_harvestable_state = HarvestableState.HARVESTED
		_regrow_timer.start(HARVESTED_TO_REGENERATING_STATE_DURATION)
		return true

	return false


func _on_regrow_timer_timeout() -> void:
	if HarvestableState.HARVESTED:
		_harvestable_state = HarvestableState.REGENERATING
		_regrow_timer.start(HARVESTED_TO_AVAILABLE_STATE_DURATION)

	if HarvestableState.REGENERATING:
		_harvestable_state = HarvestableState.AVAILABLE
