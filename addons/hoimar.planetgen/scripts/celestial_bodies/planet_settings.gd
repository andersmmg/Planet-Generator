@tool
class_name PlanetSettings
extends Resource
## This resource contains the settings for a planet.

## The resolution of the planet's terrain.
@export_range(3, 9999) var resolution: int = 20: set = set_resolution
## The radius of the planet.
@export var radius: float = 100: set = set_radius
## Whether the planet has water.
@export var has_water: bool = false: set = set_has_water
## The water level of the planet, offset from planet radius.
@export var water_level_offset: float = 0.0: set = set_water_level_offset
## Whether the planet has an atmosphere.
@export var has_atmosphere: bool = true: set = set_has_atmosphere
## Whether the planet has collisions.
@export var has_collisions: bool = true: set = set_has_collisions
## The thickness of the atmosphere.
@export_range(1.0, 10000.0) var atmosphere_thickness: float = 1.15: set = set_atmosphere_thickness
## The density of the atmosphere.
@export_range(0.0, 1.0) var atmosphere_density: float = 0.1: set = set_atmosphere_density
## The padding to add to the atmosphere radius.
@export var atmosphere_padding: float = 0.0: set = set_atmosphere_padding
## The shape generator for the planet's terrain.
@export var shape_generator: ShapeGenerator

var _planet: Node3D: get = get_planet
## Used for threads creating physics shapes.
var shared_mutex := Mutex.new()


## Initializes the planet settings.
func init(_planet):
	self._planet = _planet
	shape_generator.init(_planet)


## Called when the settings have changed.
func on_settings_changed():
	if not _planet:
		return
	_planet.generate()


## Sets the resolution of the planet's terrain.
func set_resolution(new: int):
	resolution = new
	on_settings_changed()


## Sets the radius of the planet.
func set_radius(new: float):
	radius = new
	on_settings_changed()


## Sets whether the planet has water.
func set_has_water(new: bool):
	has_water = new
	on_settings_changed()


## Sets the water level offset.
func set_water_level_offset(new: float):
	water_level_offset = new
	on_settings_changed()


## Sets whether the planet has an atmosphere.
func set_has_atmosphere(new: bool):
	has_atmosphere = new
	on_settings_changed()


## Sets the thickness of the atmosphere.
func set_atmosphere_thickness(new: float):
	atmosphere_thickness = new
	on_settings_changed()


## Sets the density of the atmosphere.
func set_atmosphere_density(new: float):
	atmosphere_density = new
	on_settings_changed()


## Sets the padding to add to the atmosphere radius.
func set_atmosphere_padding(new: float):
	atmosphere_padding = new
	on_settings_changed()

## Sets whether the planet has collisions.
func set_has_collisions(new: bool):
	has_collisions = new
	on_settings_changed()


## Returns the planet node.
func get_planet() -> Node3D:
	return _planet
