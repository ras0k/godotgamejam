extends Node2D

onready var player = get_node("/root/Main/Spaceship")

var import_good
var export_good
var inventory = 45.0
var purse = 25


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_import()
	set_export()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_import():
	$BG.modulate.a = 0.4
	if player.current_import == "blue":
		$Container/ImportGood.modulate = Color(0, 0, 1)
		import_good = "blue"
	elif player.current_import == "green":
		$Container/ImportGood.modulate = Color(0, 1, 0)
		import_good = "green"
	elif player.current_import == "red":
		$Container/ImportGood.modulate = Color(1, 0, 0)
		import_good = "red"
	else:
		$Container/ImportGood.modulate = Color(1, 1, 1)
		import_good = "white"
	

func set_export():
	if player.current_export == "blue":
		$Container/ExportGood.modulate = Color(0, 0, 1)
		export_good = "blue"
	elif player.current_export == "green":
		$Container/ExportGood.modulate = Color(0, 1, 0)
		export_good = "green"
	elif player.current_export == "red":
		$Container/ExportGood.modulate = Color(1, 0, 0)
		export_good = "red"
	else:
		$Container/ExportGood.modulate = Color(1, 1, 1)
		export_good = "white"

func _on_Buy_button_up():
	buy_goods()


func _on_Sell_button_up():
	sell_goods()

func buy_goods():
	if export_good == "blue" and Global.currency >= 3 and inventory >= 15:
		Global.blue_resource_amount += 15
		Global.currency -= 3
		inventory -= 15
	elif export_good == "green" and Global.currency >= 4 and inventory >= 15:
		Global.green_resource_amount += 15
		Global.currency -= 4
		inventory -= 15
	elif export_good == "red" and Global.currency >= 5 and inventory >= 15:
		Global.red_resource_amount += 15
		Global.currency -= 5
		inventory -= 15
	elif export_good == "white" and Global.currency >= 2 and inventory >= 15:
		Global.white_resource_amount += 15
		Global.currency -= 5
		inventory -= 15
	else:
		print("Transaction failed!")


func sell_goods():
	if import_good == "blue" and Global.blue_resource_amount >= 10.0 and purse >= 2:
		Global.blue_resource_amount -= 10.0
		Global.currency += 2
		purse -= 2
		print(Global.currency)
	elif import_good == "green" and Global.green_resource_amount >= 10.0 and purse >= 3:
		Global.green_resource_amount -= 10.0
		Global.currency += 3
		purse -= 3
		print(Global.currency)
	elif import_good == "red" and Global.red_resource_amount >= 10.0 and purse >= 4:
		Global.red_resource_amount -= 10.0
		Global.currency += 4
		purse -= 4
		print(Global.currency)
	elif import_good == "white" and Global.white_resource_amount >= 10.0 and purse > 0:
		Global.white_resource_amount -= 10
		Global.currency += 1
		purse -= 1
		print(Global.currency)
	else:
		print("Transaction Failed!")
	


func _on_Exit_button_up():
	get_tree().paused = false
	get_parent().remove_child(self)
