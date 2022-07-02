extends KinematicBody2D



func _on_NPC1_item_changed(item_name, amount):
	print("Got items: " + item_name + " " + str(amount))
