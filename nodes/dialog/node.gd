# Arrow
# Game Narrative Design Tool
# Mor. H. Golkar

# Dialog Node Type
extends GraphNode

onready var Main = get_tree().get_root().get_child(0)

const OUT_SLOT_COLOR = Settings.GRID_NODE_SLOT.DEFAULT.OUT.COLOR
# settings for the dynamically generated outgoing slots
const OUT_SLOT_ENABLE_RIGHT = true
const OUT_SLOT_ENABLE_lEFT  = false
const OUT_SLOT_TYPE_RIGHT   = Settings.GRID_NODE_SLOT.DEFAULT.OUT.TYPE
const OUT_SLOT_TYPE_LEFT    = OUT_SLOT_TYPE_RIGHT
const OUT_SLOT_COLOR_RIGHT  = OUT_SLOT_COLOR
const OUT_SLOT_COLOR_LEFT   = OUT_SLOT_COLOR

const LINE_SLOT_ALIGN = Label.ALIGN_RIGHT

const ANONYMOUS_CHARACTER = DialogSharedClass.ANONYMOUS_CHARACTER
const PLAYABLE_STATUS_MESSAGE = "Playable"
const AUTOPLAY_STATUS_MESSAGE = "Auto"

var _node_id
var _node_resource

var This = self

onready var Playable  = get_node("./Head/HBoxContainer/Playable")
# onready var CharacterProfile  = get_node("./Head/CharacterProfile")
onready var CharacterProfileName  = get_node("./Head/CharacterProfile/Name")
onready var CharacterProfileColor = get_node("./Head/CharacterProfile/Color")

#func _ready() -> void:
#	register_connections()
#	pass

#func register_connections() -> void:
#	# e.g. SOME_CHILD.connect("the_signal", self, "the_handler_on_self", [], CONNECT_DEFERRED)
#	pass

func remove_lines_all() -> void:
	for node in self.get_children():
		if node is Label:
			node.free()
	pass

func update_lines(lines:Array, clear_first:bool = true) -> void:
	if clear_first == true:
		remove_lines_all() 
	# Note: starts from `1` because there is a default `in`coming slot first at 0 index (`./Head`)
	var idx = 1 
	for line_text in lines:
		if line_text is String:
			var line_slot = Label.new()
			line_slot.set_text(line_text)
			line_slot.set_align(LINE_SLOT_ALIGN)
			This.add_child(line_slot)
			This.set_slot(
				idx,
				OUT_SLOT_ENABLE_lEFT, OUT_SLOT_TYPE_LEFT, OUT_SLOT_COLOR_LEFT,
				OUT_SLOT_ENABLE_RIGHT, OUT_SLOT_TYPE_RIGHT, OUT_SLOT_COLOR_RIGHT
			)
			idx += 1
	pass

func update_character(profile:Dictionary) -> void:
	if profile.has("name") && (profile.name is String):
		CharacterProfileName.set("text", profile.name)
	if profile.has("color") && (profile.color is String):
		CharacterProfileColor.set("color", Color(profile.color))
	pass

func set_character_anonymous() -> void:
	update_character( ANONYMOUS_CHARACTER )
	pass

func set_playable(enabled:bool = true) -> void:
	Playable.set_text( PLAYABLE_STATUS_MESSAGE if enabled else AUTOPLAY_STATUS_MESSAGE )
	pass

func _update_node(data:Dictionary) -> void:
	if data.has("lines") && (data.lines is Array):
		update_lines(data.lines, true)
	else:
		remove_lines_all()
	if data.has("playable") && (data.playable is bool):
		set_playable(data.playable)
	if data.has("character") && (data.character is int) && (data.character >= 0):
		var the_character_profile = Main.Mind.lookup_resource(data.character, "characters")
		if the_character_profile != null :
			update_character( the_character_profile )
	else:
		set_character_anonymous()
	pass
