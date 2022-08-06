extends Node

class_name RandomPicker

export(Array, Resource) var items_list: Array = []

func pick_random_item(items_array: Array = items_list):
	var chosen_value = null
	if items_list.size() > 0:
		# Calculate the overall chance
		var overall_chance: int = 0
		for item in items_array:
			if item.can_be_picked:
				overall_chance += item.pick_chance
		
		# Generate a random number
		var random_number = randi() % overall_chance
		
		# Pick a random item
		var offset: int = 0
		for item in items_array:
			if item.can_be_picked:
				if random_number < item.pick_chance + offset:
					chosen_value = item.Value
					break
				else:
					offset += item.pick_chance
		pass
		# Return the value
		
	return chosen_value
