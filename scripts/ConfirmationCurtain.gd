class_name Confirmation_Curtain extends Panel

@export var supply_display : Supply_Display
@export var supply_collection : Supply_Collection
@export var options_overseer : Options_Overseer
var supply : Supply

func open(new_supply):
	show()
	supply = new_supply
	supply_display.setup(supply.id, supply_collection, options_overseer)
	supply_display.show()

func confirm():
	supply.empty()
	close()

func close():
	hide()
