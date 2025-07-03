@tool
@icon("../../resources/icons/planet.svg")
class_name Planet
extends Node3D
## Class for a planet taking care of terrain, atmosphere, water etc.

## Generate the planet based on settings.
@export_tool_button("Generate") var generate_action = generate
## The settings for the planet.
@export var settings: PlanetSettings
## The material for the planet's terrain.
@export var material: Material
## The path to the solar system node.
@export_node_path("SolarSystem") var solar_system_path
## The path to the sun node.
@export_node_path("Sun") var sun_path

var _org_water_mesh: Mesh
var _solar_system: Node
var _logger := Logger.get_for(self)
## The mass of the planet.
var mass: float = pow(10.0, 10)   # TODO: Make this configurable through settings.
@onready var _terrain: TerrainManager = $TerrainManager
@onready var _atmosphere = $Atmosphere
@onready var _water_sphere: MeshInstance3D = $WaterSphere

var _debounce_counter := 0.0
var _needs_generate := false


## Required time between generations (in seconds)
const GENERATE_DEBOUNCE = 0.2


func _ready():
	add_to_group("planets")
	if not _org_water_mesh:
		_org_water_mesh = _water_sphere.mesh
	generate()


func _process(delta: float) -> void:
	_debounce_counter = maxf(_debounce_counter - delta, 0)
	
	if _needs_generate and _debounce_counter <= 0:
		_needs_generate = false
		generate()


## Generate whole planet.
func generate():
	if not are_conditions_met():
		return
	if _debounce_counter > 0:
		_needs_generate = true
		return
	_debounce_counter = GENERATE_DEBOUNCE
	var time_before = Time.get_ticks_msec()
	settings.init(self)
	_terrain.generate(settings, material)
	
	# Adjust water.
	_water_sphere.visible = settings.has_water
	if settings.has_water:
		var material: Material = _org_water_mesh.surface_get_material(0).duplicate()
		var mesh: SphereMesh = SphereMesh.new()
		var water_radius: float = settings.radius + settings.water_level_offset
		mesh.radius = water_radius
		mesh.height = water_radius*2
		mesh.surface_set_material(0, material)
		_water_sphere.mesh = mesh
		material.set_shader_parameter("planet_radius", settings.radius)
	
	# Adjust atmosphere.
	_atmosphere.visible = settings.has_atmosphere
	if settings.has_atmosphere:
		_atmosphere.planet_radius = settings.radius + settings.atmosphere_padding
		_atmosphere.atmosphere_height = settings.atmosphere_thickness
		_atmosphere.atmosphere_density = settings.atmosphere_density
		_atmosphere.set_sun_path("../" + str(sun_path))
		
	_logger.debug("%s%s started generating after %sms." % [name, str(self), str(Time.get_ticks_msec() - time_before)])

## Checks if the conditions for generating the planet are met.
func are_conditions_met() -> bool:
	if not settings or not material:
		_logger.warn("Settings or material not set, can't generate %s%s." %
			[name, str(self)])
		return false
	if not _terrain:
		_logger.warn("Terrain %s%s for not yet initialized." % [name, str(self)])
		return false
	var jobs: Array = PGGlobals.job_queue.get_jobs_for(self)
	if !jobs.is_empty() and not PGGlobals.benchmark_mode:
		_logger.warn("Waiting for %d jobs to finish before generating \"%s%s\"." % [jobs.size(), name, str(self)])
		return false
	return true

func _enter_tree():
	if solar_system_path:
		_solar_system = get_node(solar_system_path)
	elif get_parent().has_method("register_planet"):   # TODO: Properly find if parent is _solar_system.
		solar_system_path = ".."
		_solar_system = get_parent()
	if _solar_system:
		_solar_system.register_planet(self)

func _exit_tree():
	if _solar_system:
		_solar_system.unregister_planet(self)

func _get_configuration_warnings() -> PackedStringArray:
	var strArr = PackedStringArray([])
	if settings and settings.has_atmosphere and sun_path.is_empty():
		strArr.append("Node path to sun node is not set in 'Sun Path3D'.")
	if !solar_system_path or solar_system_path.is_empty():
		strArr.append("Node path to the solar system node is not set in 'Solar System Path3D'.")
	return strArr

# Shared configuration warnings between this class and subclasses.
func _get_common_config_warning() -> String:
	if not settings:
		return "Missing a 'PlanetSettings' resource in 'Settings'."
	if not material:
		return "Missing a 'Material' resource in 'Material'."
	return ""
