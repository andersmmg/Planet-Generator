@tool
@icon("../../resources/icons/solar_system.svg")
class_name SolarSystem
extends Node3D
## This class manages all the planets in the solar system.

var _all_planets: Array[Planet]
var _logger := Logger2.get_for(self)


## Registers a planet with the solar system.
func register_planet(planet: Planet):
	_all_planets.append(planet)


## Unregisters a planet from the solar system.
func unregister_planet(planet: Planet):
	_all_planets.erase(planet)


func _enter_tree():
	PGGlobals.register_solar_system(self)


func _exit_tree():
	PGGlobals.unregister_solar_system(self)
