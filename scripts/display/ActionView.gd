class_name Action_View extends NinePatchRect

@export var actions_display : ScrollContainer
@export var action_menu : Action_Menu
@export var supply_menu_container : ScrollContainer
@export var supply_menu : Supply_Menu

func open_menu(action : Action): #rename this open_action_menu
	actions_display.visible = false
	action_menu.visible = true
	supply_menu_container.visible = false
	if(action != null):
		action_menu.set_action(action)

func open_supply_menu(supply : Supply):
	actions_display.visible = false
	action_menu.visible = false
	supply_menu_container.visible = true
	if(supply != null):
		supply_menu.open(supply)

func open_actions_display():
	actions_display.visible = true
	action_menu.visible = false
	supply_menu_container.visible = false
