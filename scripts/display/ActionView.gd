class_name Action_View extends ColorRect

@export var actions_display : ScrollContainer
@export var action_menu_container : ScrollContainer
@export var action_menu : Action_Menu

func open_menu(action : Action):
	actions_display.visible = false
	action_menu_container.visible = true
	if(action != null):
		action_menu.set_action(action)

func open_actions_display():
	actions_display.visible = true
	action_menu_container.visible = false
