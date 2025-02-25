# Arrow
# Game Narrative Design Tool
# Mor. H. Golkar

# Quick Preferences
extends MenuButton

signal quick_preference

onready var Main = get_tree().get_root().get_child(0)

onready var QuickPreferencesPopup = self.get_popup()

const QUICK_PREFERENCES_MENU = {
	0: { "label": "Auto Inspection", "is_checkbox": true , "preference": "_AUTO_INSPECT", "command": "auto_inspect" },
	1: { "label": "Auto Node Update", "is_checkbox": true , "preference": "_AUTO_NODE_UPDATE", "command": "auto_node_update" },
}

func _ready() -> void:
	load_quick_preferences_menu()
	QuickPreferencesPopup.connect("id_pressed", self, "_on_quick_preferences_popup_item_id_pressed", [], CONNECT_DEFERRED)
	pass

func load_quick_preferences_menu() -> void:
	QuickPreferencesPopup.clear()
	for item_id in QUICK_PREFERENCES_MENU:
		var item = QUICK_PREFERENCES_MENU[item_id]
		if item == null: # separator
			QuickPreferencesPopup.add_separator()
		else:
			if item.has("is_checkbox") && item.is_checkbox == true:
				QuickPreferencesPopup.add_check_item(item.label, item_id)
			else:
				QuickPreferencesPopup.add_item(item.label, item_id)
	# update checkboxes ...
	refresh_quick_preferences_menu_view()
	pass

func refresh_quick_preferences_menu_view() -> void:
	for item_id in QUICK_PREFERENCES_MENU:
		QuickPreferencesPopup.set_item_checked( item_id, Main[ QUICK_PREFERENCES_MENU[item_id].preference ] )
	pass

func _on_quick_preferences_popup_item_id_pressed(id) -> void:
	# print_debug("Quick Preference Pressed: ", id, QUICK_PREFERENCES_MENU[id])
	self.emit_signal(
		"quick_preference",
		( ! Main[ QUICK_PREFERENCES_MENU[id].preference ] ),
		QUICK_PREFERENCES_MENU[id].command
	)
	pass
