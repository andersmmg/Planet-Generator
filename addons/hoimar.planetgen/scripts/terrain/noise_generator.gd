@tool
class_name NoiseGenerator
extends Resource
## This resource contains the settings for a noise generator.

signal updated

## Whether the noise generator is enabled.
@export var enabled: bool = true:
	set = set_enabled
## Whether to use the first noise layer as a mask for the second.
@export var use_first_as_mask: bool:
	set = set_use_first_as_mask
## The seed for the noise generator.
@export var seed_value: int:
	set = set_seed_value
## The strength of the noise.
@export var strength: float:
	set = set_strength
## The number of fractal octaves.
@export var fractal_octaves: int = 4:
	set = set_octaves
## The period of the noise.
@export var period: float = 0.03:
	set = set_period
## The frequency of the noise.
@export var frequency: float = 0.6:
	set = set_frequency
## The center of the noise.
@export var center: Vector3:
	set = set_center

# Micro-optimization to make generator functions branchless (no ifs).
var enabled_int: int
var use_first_as_mask_int: int

var _simplex: FastNoiseLite
var _planet: Node3D


## Initializes the noise generator.
func init(_planet):
	self._planet = _planet
	enabled_int = enabled
	use_first_as_mask_int = use_first_as_mask


## Updates the noise generator settings.
func update_settings():
	_simplex = FastNoiseLite.new()
	_simplex.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_simplex.seed = seed_value
	_simplex.fractal_octaves = fractal_octaves
	_simplex.fractal_type = FastNoiseLite.FRACTAL_RIDGED
	_simplex.frequency = frequency
	if _planet:
		_planet.generate()
	updated.emit()


## Evaluates the noise at a given position.
func evaluate(v: Vector3) -> float:
	if not _simplex:
		return 0.0
	return _simplex.get_noise_3dv(center + v) * strength


## Sets whether the noise generator is enabled.
func set_enabled(new):
	enabled = new
	update_settings()


## Sets the seed for the noise generator.
func set_seed_value(new):
	seed_value = new
	update_settings()


## Sets the strength of the noise.
func set_strength(new):
	strength = new
	update_settings()


## Sets the number of fractal octaves.
func set_octaves(new):
	fractal_octaves = new
	update_settings()


## Sets the period of the noise.
func set_period(new):
	period = new
	update_settings()


## Sets the frequency of the noise.
func set_frequency(new):
	frequency = new
	update_settings()


## Sets whether to use the first noise layer as a mask for the second.
func set_use_first_as_mask(new):
	use_first_as_mask = new
	update_settings()


## Sets the center of the noise.
func set_center(new):
	center = new
	update_settings()
