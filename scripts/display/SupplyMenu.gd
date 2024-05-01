class_name Supply_Menu extends Control

signal close_supply_menu

@export var supply_name : LineEdit
@export var upgrade_increase : Label
@export var current_max_value : Label
@export var custom_max_spin : SpinBox
var supply : Supply

func open(new_supply : Supply):
	supply = new_supply
	current_max_value.text = str("%.2f" % supply.v_max)
	upgrade_increase.text = str("%.2f" % supply.max_increment)

func close():
	close_supply_menu.emit()

func change_supply_name(new_name : String):
	pass
	#set_supply_name.emit(new_name)

func update_supply_name(current_name : String):
	pass
	#supply_name.text = current_name

func attempt_max_upgrade():
	supply.attempt_upgrade_max()
