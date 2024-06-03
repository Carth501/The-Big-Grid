class_name Objective_Key extends Control

@export var comparator : Label
@export var supply_icon : Supply_Icon_Display
@export var constant : Label
var supply_collection : Supply_Collection

func _ready():
	supply_collection = Logic_Directory_Single.get_object("Supply_Collection")

func set_objective_supply(id : String):
	constant.visible = false
	supply_icon.visible = true
	var supply = supply_collection.get_supply(id)
	supply_icon.set_image_by_path(supply.supply_icon_path)
	supply_icon.set_supply_name(supply.get_translation())

func set_objective_constant(value : float):
	constant.visible = true
	supply_icon.visible = false
	constant.text = str(value)

func set_comparator(symbol : String):
	comparator.text = symbol
