@tool
extends EditorPlugin
## Plugin class for Planet Generator.
##
## This plugin adds a new custom type "Solar System" to the editor,
## which can be used to create and manage celestial bodies.
## It also adds an autoload singleton "PGGlobals" for global access to plugin-related data.

const PLUGIN_ICON := preload("resources/icons/solar_system.svg")
const PG_GLOBALS_PATH = "res://addons/hoimar.planetgen/scripts/utils/pg_globals.gd"


## Called when the plugin is activated.
## Adds the "PGGlobals" autoload singleton and the "Solar System" custom type.
func _enter_tree():
	add_autoload_singleton("PGGlobals", PG_GLOBALS_PATH)


## Called when the plugin is deactivated.
## Removes the "Solar System" custom type and the "PGGlobals" autoload singleton.
func _exit_tree():
	remove_autoload_singleton("PGGlobals")


## Returns the plugin's icon.
func _get_plugin_icon() -> Texture2D:
	return PLUGIN_ICON
