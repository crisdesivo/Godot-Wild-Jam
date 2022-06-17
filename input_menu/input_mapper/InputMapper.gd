extends Node

signal profile_changed(new_profile, is_customizable)

var current_profile_id = 0
var profiles = {
	0: 'profile_custom',
	1: 'profile_normal',
	2: 'profile_alternate',
}
var profile_alternate = {
	'ui_up': KEY_W,
	'ui_down': KEY_S,
	'ui_left': KEY_A,
	'ui_right': KEY_D,
	"up": KEY_UP,
	"down": KEY_DOWN,
	"left": KEY_LEFT,
	"right": KEY_RIGHT,
	"Change Left": KEY_Q,
	"Change Right": KEY_E,
	
}
var profile_normal = {
	'ui_up': KEY_UP,
	'ui_down': KEY_DOWN,
	'ui_left': KEY_LEFT,
	'ui_right': KEY_RIGHT,
	"up": KEY_W,
	"down": KEY_S,
	"left": KEY_A,
	"right": KEY_D,
	"Change Left": KEY_0,
	"Change Right": KEY_PERIOD,
}
var profile_custom = profile_normal

func change_profile(id):
	current_profile_id = id
	var profile = get(profiles[id])
	var is_customizable = true if id == 2 else false
	
	for action_name in profile.keys():
		change_action_key(action_name, profile[action_name])
	emit_signal('profile_changed', profile, is_customizable)
	return profile

func change_action_key(action_name, key_scancode):
	erase_action_events(action_name)

	var new_event = InputEventKey.new()
	new_event.set_scancode(key_scancode)
	InputMap.action_add_event(action_name, new_event)
	get_selected_profile()[action_name] = key_scancode

func erase_action_events(action_name):
	var input_events = InputMap.get_action_list(action_name)
	for event in input_events:
		InputMap.action_erase_event(action_name, event)

func get_selected_profile():
	return get(profiles[current_profile_id])

func _on_ProfilesMenu_item_selected(ID):
	change_profile(ID)

func saveToDisk():
	var profile = get_selected_profile()
	var file = File.new()
	file.open("user://key_mapping.save", File.WRITE)
	file.store_var(profile, true)

func loadFromDisk():
	var file = File.new()
	if not file.file_exists("user://key_mapping.save"):
		return # Error! We don't have a save to load.
	file.open("user://key_mapping.save", File.READ)
	var profile = file.get_var(true)
	profile_custom = profile
	change_profile(0)