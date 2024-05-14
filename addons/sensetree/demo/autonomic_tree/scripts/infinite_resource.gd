extends StorageNode


func has_stored_resources() -> bool:
	return true


func has_free_space() -> bool:
	return true


func store_resource() -> bool:
	return true


func take_resource() -> bool:
	return true
